FactoryBot.define do
  factory :lesson_part do
    sequence :position
    association :lesson, factory: :lesson

    after :build do |lesson_part|
      # We need atleast one activity to assign the default_activity_choice in
      # the before_validation callback
      if lesson_part.activities.empty?
        lesson_part.activities = FactoryBot.build_list :activity, 5, lesson_part: lesson_part
      end
    end
  end
end
