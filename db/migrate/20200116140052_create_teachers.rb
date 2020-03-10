class CreateTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :teachers do |t|
      t.uuid :token, null: false
      t.timestamps
    end

    add_index :teachers, :token, unique: true
  end
end
