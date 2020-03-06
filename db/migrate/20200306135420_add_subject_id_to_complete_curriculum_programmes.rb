class AddSubjectIdToCompleteCurriculumProgrammes < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      # rubocop:disable Rails/NotNullColumn
      add_column :complete_curriculum_programmes, :subject_id, :integer, null: false
      # rubocop:enable Rails/NotNullColumn

      add_foreign_key :complete_curriculum_programmes, :subjects
    end
  end
end
