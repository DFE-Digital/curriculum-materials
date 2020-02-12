class CreateLessonParts < ActiveRecord::Migration[6.0]
  def change
    create_table :lesson_parts do |t|
      t.belongs_to :lesson, null: false
      t.integer :position, null: false

      t.timestamps
    end
  end
end
