require 'rails_helper'

describe LessonPart, type: :model do
  describe 'columns' do
    it do
      is_expected.to have_db_column(:lesson_id).of_type(:integer).with_options \
        null: false
    end
    it do
      is_expected.to have_db_column(:position).of_type(:integer).with_options \
        null: false
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to :lesson }
    it { is_expected.to have_many(:activities).dependent(:destroy) }
    it { is_expected.to have_many(:activity_choices).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :position }

    it do
      # explicit create to work around bug in shoulda when null constraint on
      # column see https://github.com/thoughtbot/shoulda-matchers/issues/535
      expect(create(:lesson_part)).to \
        validate_uniqueness_of(:position).scoped_to :lesson_id
    end
  end
end
