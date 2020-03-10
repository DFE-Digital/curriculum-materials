FactoryBot.define do
  factory :activity_teaching_method do
    association(:activity, factory: :activity)
    association(:teaching_method, factory: :teaching_method)
  end
end
