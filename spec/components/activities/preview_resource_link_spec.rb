require 'rails_helper'

describe Activities::PreviewResourceLink, type: :component do
  let :activity do
    create :activity, :with_pupil_resources
  end

  let :resource do
    activity.pupil_resources.last
  end

  context 'generated HTML' do
    let :page do
      Capybara::Node::Simple.new(render_inline(described_class, resource: resource))
    end

    it 'renders the correct link' do
      expect(page.find('p.preview-resource-link')).to have_link \
        text: "Preview #{resource.filename.base}",
        href: /#{resource.filename}/,
        visible: :all
    end

    it 'has a badge for the extension' do
      expect(page.find('p.preview-resource-link')).to have_css \
        'span.govuk-tag.resource-badge', text: ".#{resource.filename.extension}"
    end
  end
end
