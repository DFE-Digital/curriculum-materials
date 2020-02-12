FactoryBot.define do
  factory :activity_choice do
    association :teacher, factory: :teacher
    association :activity, factory: :activity
    association :lesson_part, factory: :lesson_part
  end
end
