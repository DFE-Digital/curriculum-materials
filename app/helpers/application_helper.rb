module ApplicationHelper
  def back_button(path)
    content_for :back_button do
      link_to 'Back', path, class: %i(govuk-back-link)
    end
  end

  def cancel_button(path, text: 'Cancel')
    secondary_button(path, text: text)
  end

  def secondary_button(path, text:, number: nil)
    button_text = if number
                    capture do
                      concat(tag.span("#{number}.", class: 'button-number-prefix'))
                      concat(text)
                    end
                  else
                    content_tag('span') { concat(text) }
                  end
    link_to(button_text, path, class: %w(govuk-button govuk-button--secondary))
  end

  def breadcrumbs(crumbs: {}, current_page:)
    content_for(:breadcrumbs) do
      render(Page::BreadcrumbsComponent, crumbs: crumbs, current_page: current_page)
    end
  end

  def govuk_chevron(colour = "currentColor")
    content_tag :svg, class: "govuk-button__start-icon", xmlns: "http://www.w3.org/2000/svg", width: "17.5", height: "19", viewBox: "0 0 33 40", role: "presentation", focusable: "false" do
      tag.path fill: colour, d: "M0 0h13l20 20-20 20H0l20-20z"
    end
  end

  def markdown(content)
    return '' if content.blank?

    markdown = Redcarpet::Markdown.new \
      Redcarpet::Render::XHTML, autolink: true, space_after_headers: true

    # rubocop:disable Rails/OutputSafety
    # Rubocop doesn't notice we're first calling sanitize before calling html_safe
    sanitize(markdown.render(content)).html_safe
    # rubocop:enable Rails/OutputSafety
  end
end
