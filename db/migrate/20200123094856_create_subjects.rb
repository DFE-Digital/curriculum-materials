class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name, null: false, limit: 64
      t.timestamps
    end

    add_index :subjects, :name, unique: true
  end
end
