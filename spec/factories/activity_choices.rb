FactoryBot.define do
  factory :activity_choice do
    activity_slug { "MyString" }
    lesson_slug { "MyString" }
    unit_slug { "MyString" }
    complete_curriculum_programme_slug { "MyString" }
    teacher { nil }
  end
end
