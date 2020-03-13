require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:unit_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:summary).of_type(:text) }
    it { is_expected.to have_db_column(:position).of_type(:integer) }

    it { is_expected.to have_db_column(:core_knowledge).of_type(:text) }
    it { is_expected.to have_db_column(:previous_knowledge).of_type(:hstore) }
    it { is_expected.to have_db_column(:vocabulary).of_type(:string).with_options(array: true) }
    it { is_expected.to have_db_column(:misconceptions).of_type(:string).with_options(array: true) }
  end

  describe 'validation' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(256) }
    end

    it { is_expected.to validate_presence_of(:summary) }
  end

  describe 'relationships' do
    it { is_expected.to belong_to(:unit) }
    it { is_expected.to have_many :lesson_parts }
  end

  describe 'methods' do
    describe '#lesson_parts_for' do
      let(:teacher) { create(:teacher) }
      it { is_expected.to respond_to(:lesson_parts_for).with(1).argument }

      subject { create(:lesson) }

      let!(:lesson_parts_with_activities) do
        create_list(:lesson_part, 2, :with_activities, lesson: subject)
      end

      let!(:lesson_parts_without_activities) do
        create_list(:lesson_part, 3, lesson: subject)
      end

      specify 'should only return lesson_part and activity pairs' do
        lesson_parts_for_teacher = subject.lesson_parts_for(teacher)
        expect(lesson_parts_for_teacher.keys.map(&:id)).to match_array(lesson_parts_with_activities.map(&:id))
      end
    end
  end

  describe 'scopes' do
    describe '.ordered_by_position' do
      let!(:second) { create(:lesson, position: 3) }
      let!(:third) { create(:lesson, position: 1) }
      let!(:first) { create(:lesson, position: 5) }

      specify 'should return the lessons in ascending order of position' do
        expect(Lesson.all).to contain_exactly(second, third, first)
        expect(Lesson.all.ordered_by_position).to contain_exactly(first, second, third)
      end
    end
  end
end
