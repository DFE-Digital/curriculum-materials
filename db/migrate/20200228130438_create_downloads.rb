class CreateDownloads < ActiveRecord::Migration[6.0]
  def change
    create_table :downloads do |t|
      t.belongs_to :teacher, null: false, foreign_key: true
      t.belongs_to :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
