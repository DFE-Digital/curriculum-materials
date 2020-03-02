FactoryBot.define do
  factory :download do
    association :teacher
    association :lesson

    trait :completed do
      after :create do |download|
        lesson_bundle_path =  \
          File.join(Rails.application.root, 'spec', 'fixtures', 'lesson_bundle.zip')

        download.lesson_bundle.attach \
          io: File.open(lesson_bundle_path),
          filename: 'lesson_bundle.zip',
          content_type: 'application/zip'

        download.transition_to! :completed
      end
    end

    trait :failed do
      after :create do |download|
        download.transition_to! :failed
      end
    end
  end
end
