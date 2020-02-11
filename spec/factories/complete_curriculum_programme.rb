FactoryBot.define do
  factory(:complete_curriculum_programme, aliases: %i(ccp)) do
    sequence(:name) { |n| "CCP #{n}" }
    overview { "Overview" }
    benefits { "Benefits" }
    slug { ActiveSupport::Inflector.parameterize(name) }

    trait(:randomised) do
      name { Faker::University.name }
      overview { Faker::Lorem.paragraph }
      benefits { Faker::Lorem.paragraphs.join("\n\n") }
    end

    trait(:with_units) do
      transient do
        number_of_units { 3 }
      end

      after(:create) do |ccp, evaluator|
        create_list(:unit, evaluator.number_of_units, complete_curriculum_programme: ccp)
      end
    end
  end
end
