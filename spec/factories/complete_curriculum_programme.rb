FactoryBot.define do
  factory(:complete_curriculum_programme, aliases: %i(ccp)) do
    sequence(:name) { |n| "CCP #{n}" }
    overview { "Overview" }
    benefits { "Benefits" }

    trait(:randomised) do
      name { Faker::University.name }
      overview { Faker::Lorem.paragraph }
      benefits { Faker::Lorem.paragraphs.join("\n\n") }
    end
  end
end
