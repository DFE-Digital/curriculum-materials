class ReplaceDefaultFlagsWithKey < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      remove_column :activities, :default, :boolean, default: false

      add_column :lesson_parts, :default_activity_id, :integer, null: true
      add_foreign_key :lesson_parts, :activities, column: :default_activity_id
      add_index :lesson_parts, :default_activity_id
    end
  end
end
