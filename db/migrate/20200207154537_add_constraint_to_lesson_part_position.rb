class AddConstraintToLessonPartPosition < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      add_index :lesson_parts, %i(position lesson_id), unique: true
    end
  end
end
