FactoryBot.define do
  attachment_path = File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')

  factory :pupil_resource do
    association :activity, factory: :activity

    type { "PupilResource" }

    after :build do |pupil_resource|
      pupil_resource.file.attach \
        io: File.open(attachment_path),
        filename: 'pupil-test-image.png',
        content_type: 'image/png'
    end

    trait :with_preview do
      after :build do |pupil_resource|
        pupil_resource.preview.attach \
          io: File.open(attachment_path),
          filename: 'pupil-test-image.png',
          content_type: 'image/png'
      end
    end
  end
end
