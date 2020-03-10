require 'rails_helper'

describe Teachers::LessonPartsHelper, type: :helper do
  describe '#activity_choice_link' do
    context 'when an activity choice is present' do
      let(:teacher) { create(:teacher) }
      let(:lesson_part) { create(:lesson_part) }
      let!(:activity_choice) { create(:activity_choice, teacher: teacher, lesson_part: lesson_part) }

      let(:expected_path) { edit_teachers_lesson_part_choice_path(lesson_part) }

      it 'should return the edit lesson part choice path' do
        expect(helper.activity_choice_link(teacher, lesson_part)).to eql(expected_path)
      end
    end

    context 'when no activity choice is present' do
      let(:teacher) { create(:teacher) }
      let(:lesson_part) { create(:lesson_part) }

      let(:expected_path) { new_teachers_lesson_part_choice_path(lesson_part) }

      it 'should return the new lesson part choice path' do
        expect(helper.activity_choice_link(teacher, lesson_part)).to eql(expected_path)
      end
    end
  end
end
