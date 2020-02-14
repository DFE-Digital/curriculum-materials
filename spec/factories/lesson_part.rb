FactoryBot.define do
  factory :lesson_part do
    sequence :position
    association :lesson, factory: :lesson

    trait(:with_activities) do
      transient do
        number_of_activities { 2 }
      end

      after(:create) do |lesson_part, evaluator|
        create_list(:activity, evaluator.number_of_activities, lesson_part: lesson_part)
      end
    end
  end
end
