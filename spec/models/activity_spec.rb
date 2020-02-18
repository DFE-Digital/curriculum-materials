require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:lesson_part_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:overview).of_type(:text) }
    it { is_expected.to have_db_column(:duration).of_type(:integer) }
    it { is_expected.to have_db_column(:extra_requirements).of_type(:string).with_options(array: true) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:lesson_part) }
    it { is_expected.to have_many(:activity_teaching_methods).dependent(:destroy) }
    it { is_expected.to have_many(:activity_choices).dependent(:destroy) }
    it { is_expected.to have_many(:teaching_methods).through(:activity_teaching_methods) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:lesson_part_id) }

    describe '#duration' do
      it { is_expected.to validate_presence_of(:duration) }
      it { is_expected.to validate_numericality_of(:duration).is_less_than_or_equal_to(60) }
    end
  end

  describe 'methods' do
    describe '#make_default!' do
      subject { create(:activity, default: false) }

      specify 'should promote the activity to be default for the lesson part' do
        subject.make_default!

        expect(subject).to be_default
      end
    end
  end

  describe 'callbacks' do
    describe 'setting the default activity at creation' do
      context 'when default arg is not supplied' do
        subject { create(:activity, default: false) }

        specify 'the activity should not be marked as default' do
          expect(subject).not_to be_default
        end
      end

      context 'when default arg is supplied' do
        subject { create(:activity, default: true) }

        specify 'the activity should be marked as default' do
          expect(subject).to be_default
        end
      end
    end
  end
end
