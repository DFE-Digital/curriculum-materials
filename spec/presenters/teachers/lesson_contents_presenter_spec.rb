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

  specify 'should have the correct number of slots' do
    expect(subject.contents).to all(be_a(Teachers::LessonContentsPresenter::Slot))
    expect(subject.contents.size).to eql(number_of_parts)
  end

  specify 'each slot should have the correct attributes' do
    lesson.lesson_parts.each.with_index(1) do |lesson_part, i|
      subject.contents.find { |slot| slot.lesson_part_id == lesson_part.id }.tap do |slot|
        activity = lesson_part.activity_for(teacher)

        expect(slot.counter).to eql(i)

        expect(slot.duration).to eql(activity.duration)
        expect(slot.overview).to eql(activity.overview)
        expect(slot.extra_requirements).to eql(activity.extra_requirements)
        expect(slot.alternatives).to match_array(activity.alternatives)
        expect(slot.teaching_methods).to match_array(activity.teaching_methods)

        expect(slot.lesson_part_id).to eql(lesson_part.id)
      end
    end
  end

  context 'when a lesson part has no activities' do
    let!(:lesson_part_with_no_activities) { create(:lesson_part, lesson: lesson) }

    it 'should be omitted from the slots' do
      expect(subject.contents.map(&:lesson_part_id)).not_to include(lesson_part_with_no_activities.id)
    end
  end

  context 'Slot#resources' do
    let :activity do
      create :activity,
             :with_pupil_resources, # previewable
             :with_teacher_resources, # previewable
             :with_slide_deck # not yet previewable
    end

    let :slot do
      described_class.new(activity.lesson_part.lesson, teacher).contents.last
    end

    subject { slot.resources }

    specify %{returns the previewable resources for the activity} do
      is_expected.to \
        match_array(activity.pupil_resources + activity.teacher_resources)
    end
  end
end
