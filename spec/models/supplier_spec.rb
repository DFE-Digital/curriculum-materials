require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 64) }
    it { is_expected.to have_db_column(:token).of_type(:string).with_options(limit: 24) }
  end

  describe 'validation' do
    describe '#name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(64) }

      describe 'uniqueness' do
        subject { create(:supplier) }
        it { is_expected.to validate_uniqueness_of(:name) }
      end
    end

    describe '#token' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:token).is_equal_to(24) }

      describe 'uniqueness' do
        subject { create(:supplier) }
        it { is_expected.to validate_uniqueness_of(:token) }
      end
    end
  end
end
