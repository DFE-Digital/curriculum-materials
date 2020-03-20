FactoryBot.define do
  factory(:lesson) do
    sequence(:name) { |n| "Lesson #{n}" }
    learning_objective { "Learning objective" }
    association(:unit, factory: :unit)
    core_knowledge_for_pupils { "Core knowledge for pupils" }
    core_knowledge_for_teachers { "Core knowledge for teachers" }
    previous_knowledge { "Previous knowledge" }
    sequence(:position)
    vocabulary { "Vocabulary" }
    misconceptions { "Misconceptions" }

    trait(:randomised) do
      name { Faker::Science.scientist }
      association(:unit, factory: %i(unit randomised))
      learning_objective { Faker::Lorem.sentence }
      core_knowledge_for_teachers { Faker::Lorem.paragraphs.join("\n\n") }
      core_knowledge_for_pupils { Faker::Lorem.paragraphs.join("\n\n") }
      previous_knowledge { Faker::Lorem.paragraphs.join("\n\n") }
      vocabulary { Faker::Lorem.paragraphs.join("\n\n") }
      misconceptions { Faker::Lorem.paragraphs.join("\n\n") }
    end
  end
end
