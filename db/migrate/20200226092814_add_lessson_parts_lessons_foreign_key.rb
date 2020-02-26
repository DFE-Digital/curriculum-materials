class AddLesssonPartsLessonsForeignKey < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      add_foreign_key :lesson_parts, :lessons
    end
  end
end
