require 'rails_helper'

describe Teachers::LessonsController, type: :controller do
  let(:teacher) { FactoryBot.create :teacher }

  before :each do
    controller.session[:token] = teacher.token
  end

  context '#show' do
    let(:lesson_file) {
      File.join(Rails.root, 'content', 'year-8-history/roman-history/1-the-battle-of-hastings/_index.md')
    }
    let(:lesson) { Lesson.from_file(lesson_file) }
    let(:activity) { lesson.activities.first.alternatives.first }

    it "displays chosen alternative activities" do

      FactoryBot.create(
        :activity_choice,
        teacher: teacher,
        activity_number: activity.number,
        activity_slug: activity.slug,
        lesson_slug: activity.lesson.slug,
        unit_slug: activity.lesson.unit.slug,
        complete_curriculum_programme_slug: activity.lesson.unit.ccp.slug
      )
      get :show, params: {
        complete_curriculum_programme_slug: lesson.unit.ccp.slug,
        unit_slug: lesson.unit.slug,
        slug: lesson.slug,
      }

      expect(assigns(:lesson_parts)).to include(activity)
    end
  end
end
