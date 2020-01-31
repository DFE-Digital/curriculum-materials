class Page::BreadcrumbsComponent < ActionView::Component::Base
  attr_reader :crumbs, :current_page

  def initialize(crumbs: {}, current_page:)
    fail("Breadcrumbs must be a hash in the format of { page => href }") unless crumbs.is_a?(Hash)

    @crumbs       = crumbs
    @current_page = current_page
  end
end
