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

  def filename
    download.lesson.name.parameterize
  end

private

  def activities
    @lesson_parts.values
  end

  def slide_decks
    activities.map(&:slide_deck_resource)
  end

  def slide_decks_tempfiles
    slide_decks
      .select { |slide_deck| slide_deck.file.attached? }
      .map do |slide_deck|
        file = Tempfile.open('ResourcePackager-') do |tempfile|
          tempfile.binmode
          slide_deck.file.download { |chunk| tempfile.write(chunk) }
          tempfile.flush
          tempfile.rewind
          tempfile
        end
        file
      end
  end

  def combined_slide_decks
    return nil unless has_slide_decks?

    @combined_slide_decks ||= PresentationMerger.write_buffer do |pres|
      slide_decks_tempfiles.each do |file|
        pres << file
      end
    end
    @combined_slide_decks
  ensure
    slide_decks_tempfiles.each do |file|
      file.close!
    end
    @combined_slide_decks
  end

  def has_slide_decks?
    slide_decks_tempfiles.any?
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
    if has_slide_decks?
      zip.put_next_entry("#{filename}.odp")
      zip.write(combined_slide_decks.string)
    end
  end
end
