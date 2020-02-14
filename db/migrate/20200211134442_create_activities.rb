class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.integer :lesson_part_id, null: false
      t.text :overview
      t.integer :duration, null: false
      t.string :extra_requirements, limit: 32, array: true
      t.boolean :default, null: false
      t.timestamps
    end

    safety_assured do
      add_foreign_key :activities, :lesson_parts
      add_index :activities, :lesson_part_id
    end
  end
end
