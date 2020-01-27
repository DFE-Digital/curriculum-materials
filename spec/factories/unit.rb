FactoryBot.define do
  factory(:unit) do
    sequence(:name) { |n| "Unit #{n}" }
    association(:complete_curriculum_programme, factory: :ccp)
    overview { "Overview" }
    benefits { "Benefits" }

    trait(:randomised) do
      name { Faker::Lorem.word.capitalize }
      association(:complete_curriculum_programme, factory: %i(ccp randomised))
      overview { Faker::Lorem.paragraph }
      benefits { Faker::Lorem.paragraphs.join("\n\n") }
    end
  end
end
