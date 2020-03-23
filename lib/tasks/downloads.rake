desc "Removes attachments from S3 for all 'historic' downloads"
namespace :downloads do
  namespace :lesson_bundles do
    task clean_up: :environment do
      Download.to_clean_up.find_in_batches(batch_size: 10) do |downloads|
        downloads.each do |download|
          download.lesson_bundle.purge
          download.transition_to! :cleaned_up
        end
      end
    end
  end
end
