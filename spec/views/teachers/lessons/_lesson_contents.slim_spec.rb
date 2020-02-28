require "rails_helper"

RSpec.describe "teachers/lessons/_lesson_contents" do
  let(:lesson) { FactoryBot.create(:lesson) }
  let(:teacher) { FactoryBot.create(:teacher) }
  let!(:lesson_parts) { FactoryBot.create_list(:lesson_part, 2, :with_activities, lesson: lesson) }
  let(:presenter) { Teachers::LessonContentsPresenter.new(lesson, teacher) }

  before :each do
    assign(:lesson, lesson)
    assign(:presenter, presenter)
  end

  it "includes the lesson parts" do
    render
    expect(rendered).to have_css('table.lesson-parts.govuk-table')
    presenter.contents.each.with_index(1) do |slot, i|
      expect(rendered).to have_css('th.govuk-table__cell.big-number', text: i)
      expect(rendered).to have_content(slot.name)
      expect(rendered).to have_content(slot.overview)
    end
  end

  it "doesn't show lesson parts when non are available" do
    lesson = FactoryBot.build_stubbed(:lesson)
    teacher = FactoryBot.build_stubbed(:teacher)

    assign(:lesson, lesson)
    assign(:presenter, Teachers::LessonContentsPresenter.new(lesson, teacher))

    render
    expect(rendered).to have_css('div.govuk-warning-text__text', text: "This lesson has no activities")
    expect(rendered).not_to have_css('table.lesson-parts.govuk-table')
  end

  context "mode: :print" do
    subject do
      render "teachers/lessons/lesson_contents", mode: :print
    end
    it "omits the ability to change activities" do
      subject
      expect(rendered).not_to match "Change activity"
    end
  end
end
