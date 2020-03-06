class AddKeyStageAndYearAttributes < ActiveRecord::Migration[6.0]
  def change
    add_column :complete_curriculum_programmes, :key_stage, :integer, null: false
    add_column :units, :year, :integer, null: false
  end
end
