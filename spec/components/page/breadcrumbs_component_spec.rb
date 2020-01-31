require "rails_helper"

RSpec.describe Page::BreadcrumbsComponent, type: :component do
  let(:crumbs) do
    { 'Eutheria': '/eutheria', 'Primates': '/eutheria/primates' }
  end

  let(:current_page) { 'Hominidae' }

  describe 'attributes' do
    subject { described_class.new(crumbs: crumbs, current_page: current_page) }

    specify 'should set the crumbs and current page correctly' do
      expect(subject.crumbs).to be(crumbs)
      expect(subject.current_page).to be(current_page)
    end
  end

  describe 'generated HTML' do
    subject do
      Capybara::Node::Simple.new(
        render_inline(described_class, crumbs: crumbs, current_page: current_page).to_html
      )
    end

    specify 'the output should comply with the GOV.UK Design System' do
      expect(subject).to have_css('.govuk-breadcrumbs > ol.govuk-breadcrumbs__list')
    end

    specify 'the breadcrumbs should link to the correct paths' do
      crumbs.each do |name, href|
        expect(subject).to have_link(name, href: href)
      end
    end

    specify 'the final breadcrumb (the current page) should not be a link' do
      expect(subject).to have_css('li', text: current_page)
      expect(subject).not_to have_link(current_page)
    end
  end
end
