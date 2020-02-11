require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:activity_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:sha256).of_type(:string).with_options(length: 64) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(256) }
    it { is_expected.to validate_length_of(:sha256).is_at_most(64) }
    it { is_expected.to validate_presence_of(:uri) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:activity) }
  end
end
