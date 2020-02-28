require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:complete_curriculum_programme_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:overview).of_type(:string) }
    it { is_expected.to have_db_column(:benefits).of_type(:text) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:complete_curriculum_programme_id) }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(256) }
    end

    describe 'overview' do
      it { is_expected.to validate_presence_of(:overview) }
      it { is_expected.to validate_length_of(:overview).is_at_most(1024) }
    end

    it { is_expected.to validate_presence_of(:benefits) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:complete_curriculum_programme) }
    it { is_expected.to have_many(:lessons).dependent(:destroy) }
  end
end
