class AddPreviousKnowledgeToLessons < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_column :lessons, :previous_knowledge, :text }
    enable_extension "hstore"
    add_column :lessons, :previous_knowledge, :hstore, null: true
  end
end
