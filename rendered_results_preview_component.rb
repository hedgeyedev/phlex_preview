require 'rouge'
class RenderedResultsPreviewComponent < ApplicationComponent
  def initialize(html)
    @html = html
    @formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    @lexer = Rouge::Lexers::HTML.new
  end

  def view_template
    common_styles
    style do
      <<-CSS
        .rendered-results-preview {
          margin: 20px;
          padding: 10px;
          border: 1px solid #ccc;
          border-radius: 5px;
        }
        .raw-html {
          white-space: pre-wrap; /* Maintains spacing and format */
          background-color: #f4f4f4;
          border: 1px dashed #ddd;
          padding: 10px;
          overflow-x: auto;
        }
        .highlight {
          background-color: #ffffcc;
        }
      CSS
    end
    style do
      Rouge::Themes::ThankfulEyes.render(scope: '.highlight').gsub("\n", "")
    end
    div(class: 'rendered-results-preview') do
      h1 { 'Rendered Results Preview' }
      hr
      unsafe_raw @html
      hr
    end
    div(class: 'rendered-results-preview raw-html') do
      h1 { 'Raw HTML' }
      div(class: 'highlight') { unsafe_raw @formatter.format(@lexer.lex(@html)) } 
    end
  end

end

# Sample invocation:
# RenderedResultsPreviewComponent.new("<h1>text</ha>")
# End Sample invocation
