require 'rails_helper'

describe Activities::PreviewResourceLink, type: :component do
  context 'generated HTML' do
    let :resource do
      create :slide_deck_resource, :with_file, :with_preview
    end

    let :page do
      Capybara::Node::Simple.new(render_inline(described_class, resource: resource))
    end

    context 'when resource has preview' do
      let(:resource) { create :slide_deck_resource, :with_file, :with_preview }

      it 'renders the correct link' do
        expect(page.find('p.preview-resource-link')).to have_link \
          text: "Preview #{resource.file.filename.base}",
          href: /#{resource.preview.filename}/,
          visible: :all
      end

      it 'has a badge for the extension' do
        expect(page.find('p.preview-resource-link')).to have_css \
          'span.govuk-tag.resource-badge', text: ".#{resource.file.filename.extension}"
      end
    end

    context 'when resource does not have a preview' do
      let(:resource) { create :slide_deck_resource, :with_file }

      it 'renders the correct link' do
        expect(page.find('p.preview-resource-link')).to have_link \
          text: "Preview #{resource.file.filename.base}",
          href: /#{resource.file.filename}/,
          visible: :all
      end

      it 'has a badge for the extension' do
        expect(page.find('p.preview-resource-link')).to have_css \
          'span.govuk-tag.resource-badge', text: ".#{resource.file.filename.extension}"
      end
    end
  end
end
