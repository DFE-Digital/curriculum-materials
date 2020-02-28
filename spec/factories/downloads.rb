FactoryBot.define do
  factory :download do
    association :teacher
    association :lesson
  end
end
