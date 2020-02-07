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
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :position }
  end
end
