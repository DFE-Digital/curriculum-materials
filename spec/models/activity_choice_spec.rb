require 'rails_helper'

describe ActivityChoice, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column :teacher_id }
    it { is_expected.to have_db_column :activity_id }
    it { is_expected.to have_db_column :lesson_part_id }
  end

  describe 'relationships' do
    it { is_expected.to belong_to :teacher }
    it { is_expected.to belong_to :activity }
    it { is_expected.to belong_to :lesson_part }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :teacher }
    it { is_expected.to validate_presence_of :activity }
    it { is_expected.to validate_presence_of :lesson_part }

    it do
      expect(create(:activity_choice)).to \
        validate_uniqueness_of(:teacher_id).scoped_to :lesson_part_id
    end
  end
end
