FactoryBot.define do
  attachment_path = File.join(Rails.application.root, 'spec', 'fixtures', '1px.png')
  slide_deck_path = File.join(Rails.application.root, 'spec', 'fixtures', 'slide_1_keyword_match_up.odp')

  factory :activity do
    association :lesson_part, factory: :lesson_part
    sequence(:name) { |n| "Activity #{n}" }
    sequence(:overview) { |n| "Overview #{n}" }
    duration { 20 }
    extra_requirements { ['PVA Glue', 'Glitter'] }
    default { false }

    after :build do |activity|
      if activity.default == nil && activity.lesson_part.activities.none?(&:default?)
        activity.default = true
      end
    end

    trait(:randomised) do
      name { Faker::Lorem.sentence }
      overview { Faker::Lorem.paragraph }
      duration { 20.step(to: 60, by: 5).to_a.sample }
    end

    trait :with_pupil_resources do
      after :create do |activity|
        activity.pupil_resources.attach \
          io: File.open(attachment_path),
          filename: 'pupil-test-image.png',
          content_type: 'image/png'
      end
    end

    trait :with_teacher_resources do
      after :create do |activity|
        activity.teacher_resources.attach \
          io: File.open(attachment_path),
          filename: 'teacher-test-image.png',
          content_type: 'image/png'
      end
    end

    trait :with_slide_deck do
      after :create do |activity|
        activity.slide_deck.attach \
          io: File.open(slide_deck_path),
          filename: 'slide-deck.odp',
          content_type: 'application/vnd.oasis.opendocument.presentation'
      end
    end
  end
end
