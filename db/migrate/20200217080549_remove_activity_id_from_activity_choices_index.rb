class RemoveActivityIdFromActivityChoicesIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :activity_choices, name: 'index_activity_choices_activity_teacher_lesson_part_ids'

    safety_assured do
      add_index :activity_choices, %i(teacher_id lesson_part_id), unique: true
    end
  end
end
