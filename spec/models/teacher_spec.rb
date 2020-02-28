require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'columns' do
    it { is_expected.to(have_db_column(:token).of_type(:uuid).with_options(null: false)) }
  end

  describe 'validation' do
    describe '#token' do
      it { is_expected.to(validate_presence_of(:token)) }

      context 'uniqueness' do
        subject { Teacher.new(token: 'aaaaaaaa-bbbb-cccc-1111-222222222222') }

        it { is_expected.to(validate_uniqueness_of(:token).case_insensitive) }
      end
    end
  end

  describe 'Relationships' do
    it { is_expected.to have_many :activity_choices }
    it { is_expected.to have_many(:activities).through :activity_choices }
  end

  context '#chosen_activities' do
    let! :teacher_1 do
      create :teacher
    end

    let! :teacher_2 do
      create :teacher
    end

    let! :lesson_1 do
      create :lesson
    end

    let! :lesson_2 do
      create :lesson
    end

    let! :lesson_1_part do
      create :lesson_part, lesson: lesson_1
    end

    let! :lesson_2_part do
      create :lesson_part, lesson: lesson_2
    end

    let! :lesson_1_part_activity_1 do
      create :activity, lesson_part: lesson_1_part
    end

    let! :lesson_1_part_activity_2 do
      create :activity, lesson_part: lesson_1_part
    end

    let! :lesson_2_part_activity_1 do
      create :activity, lesson_part: lesson_2_part
    end

    let! :teacher_1_choice do
      create :activity_choice,
             teacher: teacher_1,
             lesson_part: lesson_1_part,
             activity: lesson_1_part_activity_1
    end

    let! :teacher_1_choice_for_other_lesson do
      create :activity_choice,
             teacher: teacher_1,
             lesson_part: lesson_2_part,
             activity: lesson_2_part_activity_1
    end

    let! :teacher_2_choice do
      create :activity_choice,
             teacher: teacher_2,
             lesson_part: lesson_1_part,
             activity: lesson_1_part_activity_2
    end

    subject { teacher_1.chosen_activities lesson_1 }

    it { is_expected.to match_array [teacher_1_choice.activity] }
  end
end
