class DownloadJob < ApplicationJob
  queue_as :default

  def perform(download)
    resource_packager = ResourcePackager.new(download)

    download.lesson_bundle.attach(
      io: resource_packager.lesson_bundle,
      filename: "#{download.lesson.name.parameterize}.zip",
      content_type: 'application/zip'
    )

    download.transition_to!(:completed)
  end
end
