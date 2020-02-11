require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:unit_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:summary).of_type(:text) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }

    it { is_expected.to have_db_column(:core_knowledge).of_type(:text) }
    it { is_expected.to have_db_column(:previous_knowledge).of_type(:hstore) }
    it { is_expected.to have_db_column(:vocabulary).of_type(:string).with_options(array: true) }
    it { is_expected.to have_db_column(:misconceptions).of_type(:string).with_options(array: true) }
  end

  describe 'validation' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(256) }
    end

    it { is_expected.to validate_presence_of(:summary) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:unit) }
    it { is_expected.to have_many :lesson_parts }
  end
end
