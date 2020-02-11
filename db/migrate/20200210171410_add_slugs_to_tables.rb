class AddSlugsToTables < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def up
    add_column :complete_curriculum_programmes, :slug, :string, limit: 256
    add_column :units, :slug, :string, limit: 256
    add_column :lessons, :slug, :string, limit: 256

    CompleteCurriculumProgramme.find_each do |record|
      record.update_column(:slug, ActiveSupport::Inflector.parameterize(record.title))
    end

    Unit.find_each do |record|
      record.update_column(:slug, ActiveSupport::Inflector.parameterize(record.title))
    end

    Lesson.find_each do |record|
      record.update_column(:slug, ActiveSupport::Inflector.parameterize(record.title))
    end
    safety_assured do
      change_column_null :complete_curriculum_programmes, :slug, false
      change_column_null :units, :slug, false
      change_column_null :lessons, :slug, false
    end

    add_index :complete_curriculum_programmes, :slug, unique: true, algorithm: :concurrently
    add_index :units, [:complete_curriculum_programme_id, :slug], unique: true, algorithm: :concurrently
    add_index :lessons, [:unit_id, :slug], unique: true, algorithm: :concurrently
  end

  def down
    remove_index :complete_curriculum_programmes, :slug
    remove_index :units, [:complete_curriculum_programme_id, :slug]
    remove_index :lessons, [:unit_id, :slug]

    remove_column :complete_curriculum_programmes, :slug, :string
    remove_column :units, :slug, :string
    remove_column :lessons, :slug, :string
  end
end
