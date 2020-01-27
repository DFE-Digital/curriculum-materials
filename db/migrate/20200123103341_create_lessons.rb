class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.integer :unit_id, null: false

      t.string :name, limit: 256
      t.text :summary

      # this is called sequence in the doc, we think position makes more sense
      t.integer :position

      t.text :core_knowledge
      t.text :previous_knowledge

      t.string :vocabulary, array: true
      t.string :misconceptions, array: true

      t.timestamps
    end

    safety_assured { add_foreign_key :lessons, :units }
    add_index :lessons, :unit_id
    add_index :lessons, :name
  end
end
