require 'rails_helper'

describe Activities::PreviewResourceLink, type: :component do
  let :attachment do
    create(:slide_deck_resource, :with_preview).preview
  end

  context 'generated HTML' do
    let :page do
      Capybara::Node::Simple.new(render_inline(described_class, attachment: attachment))
    end

    it 'renders the correct link' do
      expect(page.find('p.preview-resource-link')).to have_link \
        text: "Preview #{attachment.filename.base}",
        href: /#{attachment.filename}/,
        visible: :all
    end

    it 'has a badge for the extension' do
      expect(page.find('p.preview-resource-link')).to have_css \
        'span.govuk-tag.resource-badge', text: ".#{attachment.filename.extension}"
    end
  end
end
