require "rails_helper"

RSpec.describe "teachers/lessons/print" do
  let(:lesson) { FactoryBot.create(:lesson, learning_objective: "# Big things\nwonderful") }
  let(:teacher) { FactoryBot.create(:teacher) }
  let!(:lesson_parts) { FactoryBot.create_list(:lesson_part, 2, :with_activities, lesson: lesson) }
  let(:presenter) { Teachers::LessonContentsPresenter.new(lesson, teacher) }

  before :each do
    assign(:lesson, lesson)
    assign(:presenter, presenter)
  end

  it "includes the lesson name" do
    render
    expect(rendered).to match lesson.name
  end

  it "includes the heading sections" do
    render
    expect(rendered).to have_css('h2', text: t(:heading, scope: :knowledge_overview))
    expect(rendered).to have_css('h2', text: t(:heading, scope: :lesson_contents))
  end

  it "includes the lesson learning objective from markdown format" do
    render
    expect(rendered).to match markdown(lesson.learning_objective)
  end

  it "renders partials" do
    render
    expect(rendered).to render_template("teachers/lessons/_core_knowledge_for_pupils")
    expect(rendered).to render_template("teachers/lessons/_core_knowledge_for_teachers")
    expect(rendered).to render_template("teachers/lessons/_vocabulary")
    expect(rendered).to render_template("teachers/lessons/_misconceptions")
    expect(rendered).to render_template("teachers/lessons/_previous_knowledge")
    expect(rendered).to render_template("teachers/lessons/_lesson_contents")
  end
end
