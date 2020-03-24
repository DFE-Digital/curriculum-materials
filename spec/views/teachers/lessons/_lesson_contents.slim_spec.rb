require "rails_helper"

RSpec.describe "teachers/lessons/_lesson_contents" do
  let(:number_of_parts) { 2 }
  let(:lesson) { FactoryBot.create(:lesson) }
  let(:teacher) { FactoryBot.create(:teacher) }
  let!(:lesson_parts) { FactoryBot.create_list(:lesson_part, number_of_parts, :with_activities, lesson: lesson) }
  let(:presenter) { Teachers::LessonContentsPresenter.new(lesson, teacher) }

  before :each do
    assign(:lesson, lesson)
    assign(:presenter, presenter)
  end

  it "includes the lesson parts" do
    render
    expect(rendered).to have_css('.lesson-parts')
    presenter.contents.each.with_index(1) do |slot, i|
      expect(rendered).to have_css('.counter', text: i)
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

  describe 'alternatives' do
    before { render }

    context 'when there are alternatives' do
      specify %(they should be listed) do
        lesson_parts
          .map { |lp| lp.activity_for(teacher) }
          .map(&:alternatives)
          .each do |alternative|
            expect(rendered).to have_css('li', text: alternative.name)
          end
      end
    end

    context 'when there no alternatives' do
      let!(:lesson_parts) { FactoryBot.create_list(:lesson_part, number_of_parts, :with_activities, number_of_activities: 1, lesson: lesson) }

      specify %("No alternatives" should be displayed) do
        expect(rendered).to have_content(%(No alternatives), count: number_of_parts)
      end
    end
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
