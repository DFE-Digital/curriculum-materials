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

  describe 'methods' do
    describe '#title' do
      it { is_expected.to respond_to(:title) }

      describe 'contents' do
        let(:key_stage) { 4 }
        let(:school_subject_name) { 'Defence against the dark arts' }
        let(:school_subject) { create(:subject, name: school_subject_name) }
        subject { create(:ccp, subject: school_subject, key_stage: key_stage) }

        specify 'contains the key stage' do
          expect(subject.title).to include("Key stage #{key_stage}")
        end

        specify 'contains the subject' do
          expect(subject.title).to include(school_subject_name)
        end
      end
    end
  end
end
