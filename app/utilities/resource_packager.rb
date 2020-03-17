require 'zip'
require_relative '../lib/presentation_merger'

class ResourcePackager
  attr_accessor :download

  def initialize(download)
    @download     = download
    @lesson_parts = download.lesson_parts
  end

  def lesson_bundle
    build_lesson_bundle.tap(&:rewind)
  end

private

  def activities
    @lesson_parts.values
  end

  def slide_decks
    activities.map(&:slide_deck)
  end

  def slide_deck_tempfiles
    slide_decks.map { |activity| activity.attachment.open { |f| f } if activity.attached? }.compact
  end

  def combined_slide_deck
    return nil if slide_deck_tempfiles.empty?

    PresentationMerger.write_buffer do |pres|
      slide_deck_tempfiles.each do |file|
        pres << file
      end
    end
  end

  def pupil_resource_blobs
    PupilResource.where(activity: activities).includes(:file_attachment).map(&:file).map(&:blob)
  end

  def teacher_resource_blobs
    TeacherResource.where(activity: activities).includes(:file_attachment).map(&:file).map(&:blob)
  end

  def build_lesson_bundle
    Zip::OutputStream.write_buffer do |zip|
      teacher_resource_blobs.each { |blob| add_to_zip(zip, blob, resource_type: 'teacher') }
      pupil_resource_blobs.each   { |blob| add_to_zip(zip, blob, resource_type: 'pupil') }
      add_presentation_to_zip(zip)
    end
  end

  def add_to_zip(zip, blob, resource_type:)
    zip.put_next_entry(File.join(resource_type, blob.filename.to_s))
    zip.write(blob.download)
  end

  def add_presentation_to_zip(zip)
    if combined_slide_deck
      zip.put_next_entry('teacher/presentation.odp')
      zip.print(combined_slide_deck)
    end
  end
end
