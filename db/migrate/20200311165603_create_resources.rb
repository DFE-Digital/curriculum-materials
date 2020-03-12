class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.belongs_to :activity, null: false, foreign_key: true
      t.string :type, null: false

      t.timestamps
    end
  end
end
