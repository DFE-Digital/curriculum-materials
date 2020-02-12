class CreateActivityChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_choices do |t|
      t.integer :activity_number
      t.string :activity_slug
      t.string :lesson_slug
      t.string :unit_slug
      t.string :complete_curriculum_programme_slug
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
    add_index :activity_choices,
      [:activity_number, :lesson_slug, :unit_slug, :complete_curriculum_programme_slug],
      unique: true,
      name: 'activity_choices_slug_index'

  end
end
