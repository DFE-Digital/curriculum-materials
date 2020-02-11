class CreateActivityTeachingMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_teaching_methods do |t|
      t.integer :teaching_method_id, null: false
      t.integer :activity_id, null: false
      t.timestamps
    end

    safety_assured do
      add_index :activity_teaching_methods,
                %i(teaching_method_id activity_id),
                unique: true,
                name: 'index_activity_teaching_methods_teaching_method_id_activity_id'

      add_index :activity_teaching_methods, :activity_id

      add_foreign_key :activity_teaching_methods, :teaching_methods
      add_foreign_key :activity_teaching_methods, :activities
    end
  end
end
