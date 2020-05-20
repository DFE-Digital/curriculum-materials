FactoryBot.define do
  factory :activity do
    association :lesson_part, factory: :lesson_part
    sequence(:name) { |n| "Activity #{n}" }
    overview { 'Overview' }
    guidance { 'Guidance' }
    duration { 20 }
    extra_requirements { ['PVA Glue', 'Glitter'] }

    trait(:randomised) do
      name { Faker::Lorem.sentence }
      overview { Faker::Lorem.paragraph }
      duration { 20.step(to: 60, by: 5).to_a.sample }
    end

    trait :with_pupil_resources do
      after :create do |activity|
        create_list \
          :pupil_resource, 1, :with_preview, activity: activity
      end
    end

    trait :with_teacher_resources do
      after :create do |activity|
        create_list \
          :teacher_resource, 1, :with_preview, activity: activity
      end
    end

    trait :with_slide_deck do
      after :create do |activity|
        create \
          :slide_deck_resource, :with_preview, activity: activity
      end
    end
  end
end
