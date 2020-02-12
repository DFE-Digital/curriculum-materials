require 'rails_helper'

RSpec.describe TeachingMethod, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 32) }
    it { is_expected.to have_db_column(:description).of_type(:text) }
    it { is_expected.to have_db_column(:icon).of_type(:string) }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:activity_teaching_methods) }
    it { is_expected.to have_many(:activities).through(:activity_teaching_methods) }
  end

  describe 'validation' do
    describe '#name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(32) }
    end
  end
end
