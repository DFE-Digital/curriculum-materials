class FixNilArrayColumns < ActiveRecord::Migration[6.0]
  def change
    Lesson.where(vocabulary: nil).update_all(vocabulary: [])
    Lesson.where(misconceptions: nil).update_all(misconceptions: [])
    Activity.where(extra_requirements: nil).update_all(extra_requirements: [])

    change_column_default :lessons, :vocabulary, from: nil, to: []
    change_column_default :lessons, :misconceptions, from: nil, to: []
    change_column_default :activities, :extra_requirements, from: nil, to: []
  end
end
