require 'rails_helper'

RSpec.describe CompleteCurriculumProgramme, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:overview).of_type(:string) }
    it { is_expected.to have_db_column(:benefits).of_type(:text) }
  end

  describe 'validation' do
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
    it { is_expected.to have_many(:units).dependent(:destroy) }
  end
end
