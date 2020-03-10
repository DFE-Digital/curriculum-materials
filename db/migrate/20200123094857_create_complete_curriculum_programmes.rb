class CreateCompleteCurriculumProgrammes < ActiveRecord::Migration[6.0]
  def change
    create_table :complete_curriculum_programmes do |t|
      t.string :name, null: false, limit: 256
      t.text :rationale, null: false

      t.timestamps
    end

    add_index :complete_curriculum_programmes, :name
  end
end
