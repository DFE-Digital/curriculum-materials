require 'rails_helper'

RSpec.describe Teachers::LessonContentsPresenter do
  let(:number_of_parts) { 3 }
  let(:teacher) { FactoryBot.create(:teacher) }
  let(:lesson) { FactoryBot.create(:lesson) }

  before do
    number_of_parts.times do
      FactoryBot.create(:lesson_part, :with_activities, lesson: lesson)
    end
  end

  subject { Teachers::LessonContentsPresenter.new(lesson, teacher) }

  describe 'attributes' do
    it { is_expected.to respond_to(:lesson) }
    it { is_expected.to respond_to(:teacher) }
    it { is_expected.to respond_to(:contents) }
  end

  specify 'should have the correct number of slots' do
    expect(subject.contents).to all(be_a(Teachers::LessonContentsPresenter::Slot))
    expect(subject.contents.size).to eql(number_of_parts)
  end

  specify 'each slot should have the correct attributes' do
    lesson.lesson_parts.each.with_index(1) do |lesson_part, i|
      subject.contents.find { |slot| slot.lesson_part.id == lesson_part.id }.tap do |slot|
        activity = lesson_part.activity_for(teacher)

        expect(slot.counter).to eql(i)

        expect(slot.duration).to eql(activity.duration)
        expect(slot.overview).to eql(activity.overview)
        expect(slot.extra_requirements).to eql(activity.extra_requirements)
        expect(slot.alternatives).to match_array(activity.alternatives)
        expect(slot.teaching_methods).to match_array(activity.teaching_methods)

        expect(slot.lesson_part.id).to eql(lesson_part.id)
      end
    end
  end

  context 'when a lesson part has no activities' do
    let!(:lesson_part_with_no_activities) { create(:lesson_part, lesson: lesson) }

    it 'should be omitted from the slots' do
      expect(subject.contents.map(&:lesson_part)).not_to include(lesson_part_with_no_activities)
    end
  end

  context 'Slot#resources' do
    let :activity do
      create :activity
    end

    let! :teacher_resource do
      create :teacher_resource, :with_file, :with_preview, activity: activity
    end

    let! :pupil_resource do
      create :teacher_resource, :with_file, activity: activity
    end

    let! :slide_deck do
      create :slide_deck_resource, :with_file, :with_preview, activity: activity
    end

    let :slot do
      described_class.new(activity.lesson_part.lesson, teacher).contents.last
    end

    subject { slot.resources }

    specify %{returns the previewable resources for the activity} do
      # NOTE activie storage attached, which is what's returned from
      # Slot#resources, doesn't implement == (falls back to basic object ==)
      # so we can't directly compare objects, hence we need to compare the
      # filename instead.
      expect(subject.map(&:filename)).to match_array \
        [teacher_resource.preview.filename, slide_deck.preview.filename]
    end
  end
end
