class CreateSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :suppliers do |t|
      t.string :name, limit: 64, null: false
      t.string :token, limit: 24, null: true

      t.timestamps
    end

    add_index :suppliers, :name, unique: true
    add_index :suppliers, :token, unique: true
  end
end
