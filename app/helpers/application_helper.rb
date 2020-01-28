module ApplicationHelper
  def back_button(path)
    content_for :back_button do
      link_to 'Back', path, class: %i(govuk-back-link)
    end
  end

  def govuk_chevron(colour = "currentColor")
    content_tag :svg, class: "govuk-button__start-icon", xmlns: "http://www.w3.org/2000/svg", width: "17.5", height: "19", viewBox: "0 0 33 40", role: "presentation", focusable: "false" do
      tag.path fill: colour, d: "M0 0h13l20 20-20 20H0l20-20z"
    end
  end
end
