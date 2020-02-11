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
    it { is_expected.to have_many(:teaching_methods).through(:activity_teaching_methods) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:lesson_part_id) }

    describe '#duration' do
      it { is_expected.to validate_presence_of(:duration) }
      it { is_expected.to validate_numericality_of(:duration).is_less_than_or_equal_to(60) }
    end
    it { is_expected.to have_db_column(:lesson_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:slug).of_type(:string).with_options(length: 256) }
    it { is_expected.to have_db_column(:summary).of_type(:text) }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(256) }
    it { is_expected.to validate_presence_of(:slug) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:lesson) }
  end
end
