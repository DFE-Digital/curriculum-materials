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

      let(:lesson_parts_with_activities) do
        4.times.map do
          double(LessonPart, activity_for: build(:activity))
        end
      end

      let(:lesson_parts_without_activities) do
        3.times.map do
          double(LessonPart, activity_for: nil)
        end
      end

      let(:lesson_parts) { lesson_parts_with_activities + lesson_parts_without_activities }

      subject { create(:lesson) }

      before do
        allow(subject).to receive(:lesson_parts).and_return(lesson_parts)
      end

      specify 'should call LessonPart#activity_for for every lesson part' do
        subject.lesson_parts_for(teacher)
        expect(subject.lesson_parts).to all(have_received(:activity_for).with(teacher))
      end

      specify 'should only return lesson_part and activity pairs' do
        expect(subject.lesson_parts_for(teacher).size).to be(lesson_parts_with_activities.size)
      end
    end
  end
end
