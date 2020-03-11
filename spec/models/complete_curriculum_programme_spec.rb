require 'rails_helper'

RSpec.describe CompleteCurriculumProgramme, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
  end

  describe 'validation' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(256) }
    end

    it { is_expected.to validate_presence_of(:rationale) }
    it { is_expected.to validate_inclusion_of(:key_stage).in_array(SchoolYear.instance.key_stages) }
  end

  describe 'relationships' do
    it { is_expected.to have_many(:units).dependent(:destroy) }
    it { is_expected.to belong_to(:subject) }
  end
end
