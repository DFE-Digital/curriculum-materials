require 'rails_helper'

describe "teachers/lessons/_preview" do
  let! :activity do
    create :activity, :with_pupil_resources, :with_teacher_resources
  end

  before :each do
    render partial: "teachers/lessons/preview.slim",
           locals: { resources: resources }
  end

  context 'multiple resources' do
    let :resources do
      activity.pupil_resources + activity.teacher_resources
    end

    it 'renders a details list of previews' do
      page = Capybara.string rendered

      summary = page.find \
        %{details.govuk-details > summary.govuk-details__summary > .govuk-details__summary-text}

      details = page.find \
        %{details.govuk-details > .govuk-details__text}, visible: :all

      expect(summary).to have_text 'Preview resources'

      resources.each do |resource|
        expect(details).to have_link \
          text: "Preview #{resource.file.filename.base}", href: /#{resource.preview.filename}/, visible: :all
      end
    end
  end

  context 'single preview' do
    let :resources do
      activity.pupil_resources
    end

    let :resource do
      resources.first
    end

    it 'renders a link to the resource' do
      expect(rendered).not_to have_css %{details.govuk-details}
      expect(rendered).to have_link \
        text: "Preview #{resource.file.filename.base}", href: /#{resource.preview.filename}/, visible: :all
    end
  end

  context 'no resource' do
    let :resources do
      []
    end

    it "doesn't render anything" do
      expect(rendered).to be_empty
    end
  end
end
