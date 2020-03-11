class AddKeyStageAndYearAttributes < ActiveRecord::Migration[6.0]
  def change
     # rubocop:disable Rails/NotNullColumn
    add_column :complete_curriculum_programmes, :key_stage, :integer, null: false
    add_column :units, :year, :integer, null: false
     # rubocop:enable Rails/NotNullColumn
  end
end
