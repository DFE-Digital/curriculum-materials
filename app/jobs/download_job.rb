class DownloadJob < ApplicationJob
  # We don't want to retry the job if it fails as we'll be leaving the
  # teacher waiting for their download. Instead the teacher can manually
  # trigger another download.
  discard_on StandardError do |job, error|
    download = job.arguments.first
    download.transition_to! :failed
    Raven.capture_exception error
  end

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
