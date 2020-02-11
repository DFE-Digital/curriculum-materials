class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.references :activity, null: false, foreign_key: true
      t.string :name, limit: 256, null: false
      t.string :sha256, limit: 64, null: false
      t.text :taxonomies
      t.text :uri

      t.timestamps
    end
    add_index :resources, :sha256, unique: true
  end
end
