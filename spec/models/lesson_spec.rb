require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:unit_id).of_type(:integer) }
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(limit: 128, null: false) }
    it { is_expected.to have_db_column(:learning_objective).of_type(:string).with_options(limit: 256, null: false) }
    it { is_expected.to have_db_column(:position).of_type(:integer).with_options(null: false) }

    it { is_expected.to have_db_column(:core_knowledge_for_pupils).of_type(:text) }
    it { is_expected.to have_db_column(:core_knowledge_for_teachers).of_type(:text) }
    it { is_expected.to have_db_column(:previous_knowledge).of_type(:text) }
    it { is_expected.to have_db_column(:vocabulary).of_type(:text) }
    it { is_expected.to have_db_column(:misconceptions).of_type(:text) }
  end

  describe 'validation' do
    describe 'name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_length_of(:name).is_at_most(128) }
    end

    describe 'learning_objective' do
      it { is_expected.to validate_presence_of(:learning_objective) }
      it { is_expected.to validate_length_of(:learning_objective).is_at_most(256) }
    end
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

    describe '#activities_for' do
      let! :teacher do
        create :teacher
      end

      let! :lesson do
        create :lesson
      end

      let! :lesson_part_1 do
        create :lesson_part, lesson: lesson
      end

      let! :lesson_part_2 do
        create :lesson_part, lesson: lesson
      end

      let! :lesson_part_3 do
        create :lesson_part, lesson: lesson
      end

      let! :lesson_part_4 do
        create :lesson_part, lesson: lesson
      end

      let! :activity_with_pupil_resource do
        create :activity, :with_pupil_resources, lesson_part: lesson_part_1
      end

      let! :activity_with_teacher_resource do
        create :activity, :with_teacher_resources, lesson_part: lesson_part_2
      end

      let! :activity_with_slide_deck do
        create :activity, :with_slide_deck, lesson_part: lesson_part_3
      end

      let! :activity_with_no_resource do
        create :activity, lesson_part: lesson_part_4
      end

      subject { lesson.reload.activities_for teacher }

      it do
        is_expected.to match_array [
          activity_with_pupil_resource,
          activity_with_teacher_resource,
          activity_with_slide_deck,
          activity_with_no_resource
        ]
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
