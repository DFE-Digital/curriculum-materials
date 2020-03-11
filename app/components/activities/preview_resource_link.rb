module Activities
  class PreviewResourceLink < ActionView::Component::Base
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def filename
      resource.filename
    end

    def base
      filename.base
    end

    def extension
      filename.extension
    end

    def preview_path
      # NOTE this will want changing to link to the preview variant when we
      # add in previews for odp, odt, etc
      url_for resource
    end

    def badge
      tag.span ".#{extension}", class: %w(govuk-tag resource-badge)
    end
  end
end
