require 'rails_helper'

describe "teachers/lessons/_preview" do
  let! :activity do
    create :activity, :with_pupil_resources, :with_teacher_resources
  end

  before :each do
    render partial: "teachers/lessons/preview.slim",
           locals: { previews: previews }
  end

  context 'multiple previews' do
    let :previews do
      activity.pupil_resources.map(&:preview) \
        + activity.teacher_resources.map(&:preview)
    end

    it 'renders a details list of previews' do
      page = Capybara.string rendered

      summary = page.find \
        %{details.govuk-details > summary.govuk-details__summary > .govuk-details__summary-text}

      details = page.find \
        %{details.govuk-details > .govuk-details__text}, visible: :all

      expect(summary).to have_text 'Preview resources'

      previews.each do |preview|
        expect(details).to have_link \
          text: "Preview #{preview.filename.base}", href: /#{preview.filename}/, visible: :all
      end
    end
  end

  context 'single preview' do
    let :previews do
      activity.pupil_resources.map(&:preview)
    end

    let :preview do
      previews.first
    end

    it 'renders a link to the preview' do
      expect(rendered).not_to have_css %{details.govuk-details}
      expect(rendered).to have_link \
        text: "Preview #{preview.filename.base}", href: /#{preview.filename}/, visible: :all
    end
  end

  context 'no preview' do
    let :previews do
      []
    end

    it "doesn't render anything" do
      expect(rendered).to be_empty
    end
  end
end
