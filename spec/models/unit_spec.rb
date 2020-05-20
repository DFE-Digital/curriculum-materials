require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:complete_curriculum_programme_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(length: 128) }
    it { is_expected.to have_db_column(:summary).of_type(:string).with_options(length: 1024) }
    it { is_expected.to have_db_column(:rationale).of_type(:text) }
    it { is_expected.to have_db_column(:guidance).of_type(:text) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:complete_curriculum_programme_id) }

    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(128) }
    end

    describe 'summary' do
      it { is_expected.to validate_presence_of(:summary) }
      it { is_expected.to validate_length_of(:summary).is_at_most(1024) }
    end

    it { is_expected.to validate_presence_of(:rationale) }
    it { is_expected.to validate_presence_of(:guidance) }
    it { is_expected.to validate_inclusion_of(:year).in_array(SchoolYear.instance.years) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:complete_curriculum_programme) }
    it { is_expected.to have_many(:lessons).dependent(:destroy) }
  end

  describe 'scopes' do
    describe '.ordered_by_position' do
      let!(:second) { create(:unit, position: 3) }
      let!(:third) { create(:unit, position: 1) }
      let!(:first) { create(:unit, position: 5) }

      specify 'should return the units in ascending order of position' do
        expect(Unit.all).to contain_exactly(second, third, first)
        expect(Unit.all.ordered_by_position).to contain_exactly(first, second, third)
      end
    end
  end
end
