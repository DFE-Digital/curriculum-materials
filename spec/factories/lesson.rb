FactoryBot.define do
  factory(:lesson) do
    sequence(:name) { |n| "Lesson #{n}" }
    sequence(:summary) { |n| "Lesson #{n}" }
    association(:unit, factory: :unit)
    slug { ActiveSupport::Inflector.parameterize(name) }
    core_knowledge { "Core knowledge" }
    previous_knowledge { { "Previous knowledge" => "Yes" } }
    vocabulary { %w(Subtraction Division Multiplication) }
    misconceptions { [%(Fractions are not natural numbers)] }

    trait(:randomised) do
      name { Faker::Science.scientist }
      association(:unit, factory: %i(unit randomised))
      core_knowledge { Faker::Lorem.paragraphs.join("\n\n") }
      previous_knowledge { Faker::Lorem.paragraphs.join("\n\n") }
      vocabulary { Faker::Lorem.paragraphs }
      misconceptions { Faker::Lorem.paragraphs }
    end
  end
end
