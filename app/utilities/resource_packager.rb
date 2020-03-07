require 'zip'

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

  def combined_slide_deck
    # TODO retrieve the combined slide deck
    # activities.map { |activity| activity.slide_deck }
  end

  def pupil_resource_blobs
    activities.map(&:pupil_resources).flat_map(&:blobs)
  end

  def teacher_resource_blobs
    activities.map(&:teacher_resources).flat_map(&:blobs)
  end

  def build_lesson_bundle
    Zip::OutputStream.write_buffer do |zip|
      teacher_resource_blobs.each { |blob| add_to_zip(zip, blob, resource_type: 'teacher') }
      pupil_resource_blobs.each   { |blob| add_to_zip(zip, blob, resource_type: 'pupil') }

      # TODO add the combined_slide_deck
    end
  end

  def add_to_zip(zip, blob, resource_type:)
    zip.put_next_entry(File.join(resource_type, blob.filename.to_s))
    zip.write(blob.download)
  end
end
