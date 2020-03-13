module Activities
  class PreviewResourceLink < ActionView::Component::Base
    attr_reader :attachment

    def initialize(attachment:)
      @attachment = attachment
    end

    def filename
      attachment.filename
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
      url_for attachment
    end

    def badge
      tag.span ".#{extension}", class: %w(govuk-tag resource-badge)
    end
  end
end
