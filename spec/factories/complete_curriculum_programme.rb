FactoryBot.define do
  factory(:complete_curriculum_programme, aliases: %i(ccp)) do
    sequence(:name) { |n| "CCP #{n}" }
    association(:subject, factory: :subject)
    rationale { "Rationale" }
    guidance { "Guidance" }
    key_stage { [1, 2, 3, 4].sample }

    trait(:randomised) do
      name { Faker::University.name }
      rationale { Faker::Lorem.paragraphs.join("\n\n") }
      guidance { Faker::Lorem.paragraphs.join("\n\n") }
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
