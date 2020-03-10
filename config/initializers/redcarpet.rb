class Redcarpet::Render::SmartyPantsHTML < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end

Slim::Embedded.set_options(markdown: { renderer: Redcarpet::Render::SmartyPantsHTML.new })
