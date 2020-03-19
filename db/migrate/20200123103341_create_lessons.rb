class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.integer :unit_id, null: false

      t.string :name, limit: 128, null: false
      t.string :learning_objective, limit: 256, null: false

      t.integer :position, null: false

      t.text :core_knowledge_for_teachers
      t.text :core_knowledge_for_pupils

      t.text :previous_knowledge

      t.text :vocabulary
      t.text :misconceptions

      t.timestamps
    end

    safety_assured { add_foreign_key :lessons, :units }
    add_index :lessons, :unit_id
    add_index :lessons, :name
  end
end
