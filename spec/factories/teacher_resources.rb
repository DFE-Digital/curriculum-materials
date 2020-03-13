FactoryBot.define do
  attachment_path = File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')

  factory :teacher_resource do
    association :activity, factory: :activity

    type { "TeacherResource" }

    after :build do |teacher_resource|
      teacher_resource.file.attach \
        io: File.open(attachment_path),
        filename: 'teacher-test-image.png',
        content_type: 'image/png'
    end

    trait :with_preview do
      after :build do |teacher_resource|
        teacher_resource.preview.attach \
          io: File.open(attachment_path),
          filename: 'teacher-test-image.png',
          content_type: 'image/png'
      end
    end
  end
end
