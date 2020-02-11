class CreateTeachingMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :teaching_methods do |t|
      t.string :name, null: false, limit: 32
      t.text :description
      t.string :icon, limit: 64

      t.timestamps
    end
  end
end
