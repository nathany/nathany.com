require 'redcarpet'
require 'coderay'

class Syntactical < Redcarpet::Render::HTML
  def block_code(code, language)
    CodeRay.scan(code, language).div(:css => :class)
  end
end

class SyntacticalTemplate < Tilt::RedcarpetTemplate::Redcarpet2
  def generate_renderer
    Syntactical.new(hard_wrap: true)
  end

  def prepare
    # override the options to include code fencing, etc.
    options = {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: false,
      superscript: true
    }
    @engine = Redcarpet::Markdown.new(generate_renderer, options)
    @output = nil
  end
end

Tilt::register SyntacticalTemplate, 'mdown'
Tilt.prefer SyntacticalTemplate
