FactoryBot.define do
  factory :activity do
    association :lesson_part, factory: :lesson_part
    sequence(:overview) { |n| "Overview #{n}" }
    duration { 20 }
    default { false }

    after :build do |activity|
      if activity.default == nil && activity.lesson_part.activities.none?(&:default?)
        activity.default = true
      end
    end

    trait(:randomised) do
      overview { Faker::Lorem.paragraph }
      duration { 20.step(to: 60, by: 5).to_a.sample }
    end
  end
end
