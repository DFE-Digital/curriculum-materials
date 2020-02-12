class CreateActivityChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_choices do |t|
      t.belongs_to :teacher, null: false, foreign_key: true
      t.belongs_to :activity, null: false, foreign_key: true
      t.belongs_to :lesson_part, null: false, foreign_key: true

      t.timestamps
    end

    add_index :activity_choices,
              %i(activity_id teacher_id lesson_part_id),
              unique: true,
              name: 'index_activity_choices_activity_teacher_lesson_part_ids'
  end
end
