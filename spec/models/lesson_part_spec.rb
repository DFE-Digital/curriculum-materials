require 'rails_helper'

describe LessonPart, type: :model do
  describe 'columns' do
    it do
      is_expected.to have_db_column(:lesson_id).of_type(:integer).with_options \
        null: false
    end
    it do
      is_expected.to have_db_column(:position).of_type(:integer).with_options \
        null: false
    end
  end

  describe 'relationships' do
    it { is_expected.to belong_to :lesson }
    it { is_expected.to have_many(:activities).dependent(:destroy) }
    it { is_expected.to have_many(:activity_choices).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :position }

    it do
      # explicit create to work around bug in shoulda when null constraint on
      # column see https://github.com/thoughtbot/shoulda-matchers/issues/535
      expect(create(:lesson_part)).to \
        validate_uniqueness_of(:position).scoped_to :lesson_id
    end
  end

  describe 'methods' do
    subject { LessonPart.new }

    describe '#activity_for' do
      it { is_expected.to respond_to(:activity_for).with(1).arguments }

      context 'when an activity choice is present' do
        let(:activity_choice) { create(:activity_choice) }
        let(:teacher) { activity_choice.teacher }
        subject { activity_choice.lesson_part }

        specify 'the linked activity should be returned' do
          expect(subject.activity_for(teacher)).to eql(activity_choice.activity)
        end
      end

      context 'when no activity choice is present' do
        let(:teacher) { create(:teacher) }

        context 'when a default is set' do
          subject { create(:lesson_part) }
          let!(:default_activity) { create(:activity, default: true, lesson_part: subject) }
          before { create(:activity, lesson_part: subject) }

          specify 'the default activity should be returned' do
            expect(subject.activity_for(teacher)).to eql(default_activity)
          end
        end

        context 'when no default activity is set' do
          subject { create(:lesson_part) }
          let!(:first_activity) { create(:activity, default: true, lesson_part: subject) }
          before { create_list(:activity, 2, default: false, lesson_part: subject) }

          specify 'the first activity should be returned' do
            expect(subject.activity_for(teacher)).to eql(first_activity)
          end
        end
      end
    end
  end

  describe 'scopes' do
    describe '.ordered_by_position' do
      let!(:second) { create(:lesson_part, position: 3) }
      let!(:third) { create(:lesson_part, position: 1) }
      let!(:first) { create(:lesson_part, position: 5) }

      specify 'should return the lesson parts in ascending order of position' do
        expect(LessonPart.all).to contain_exactly(second, third, first)
        expect(LessonPart.all.ordered_by_position).to contain_exactly(first, second, third)
      end
    end
  end
end
