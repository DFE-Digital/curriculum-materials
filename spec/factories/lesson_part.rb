FactoryBot.define do
  factory :lesson_part do
    sequence :position
    association :lesson, factory: :lesson
  end
end
