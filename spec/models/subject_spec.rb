require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 64) }
  end

  describe 'indices' do
    it { is_expected.to have_db_index(:name).unique }
  end

  describe 'validation' do
    describe '#name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(64) }
    end
  end

  describe 'relationships' do
    it { is_expected.to have_many(:complete_curriculum_programmes).dependent(:destroy) }
  end
end
