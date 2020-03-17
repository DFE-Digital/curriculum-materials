module Activities
  class PreviewResourceLink < ActionView::Component::Base
    attr_reader :resource

    def initialize(resource:)
      @resource = resource
    end

    def filename
      resource.file.filename
    end

    def base
      filename.base
    end

    def extension
      filename.extension
    end

    def preview_path
      if resource.preview.attached?
        url_for resource.preview
      else
        url_for resource.file
      end
    end

    def badge
      tag.span ".#{extension}", class: %w(govuk-tag resource-badge)
    end
  end
end
