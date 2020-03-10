FactoryBot.define do
  factory(:unit) do
    sequence(:name) { |n| "Unit #{n}" }
    association(:complete_curriculum_programme, factory: :ccp)
    overview { "Overview" }
    benefits { "Benefits" }
    sequence(:position) { |n| n }

    trait(:randomised) do
      name { Faker::Lorem.word.capitalize }
      association(:complete_curriculum_programme, factory: %i(ccp randomised))
      overview { Faker::Lorem.paragraph }
      benefits { Faker::Lorem.paragraphs.join("\n\n") }
    end

    trait(:with_lessons) do
      transient do
        number_of_lessons { 3 }
      end

      after(:create) do |unit, evaluator|
        create_list(:lesson, evaluator.number_of_lessons, unit: unit)
      end
    end
  end
end
