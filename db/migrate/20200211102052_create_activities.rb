class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :lesson, null: false, foreign_key: true
      t.string :name, limit: 256, null: false
      t.string :slug, limit: 256, null: false
      t.text :summary

      t.timestamps
    end
    add_index :activities, [:lesson_id, :slug], unique: true
  end
end
