class CreateUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :units do |t|
      t.integer :complete_curriculum_programme_id

      t.string :name, null: false, limit: 256
      t.string :overview, null: false, limit: 1024
      t.text :benefits, null: false
      t.integer :position

      t.timestamps
    end

    safety_assured { add_foreign_key :units, :complete_curriculum_programmes }
    add_index :units, :complete_curriculum_programme_id
    add_index :units, :name
  end
end
