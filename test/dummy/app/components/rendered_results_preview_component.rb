class RenderedResultsPreviewComponent < Phlex::HTML

  def self.component_props
    [
      PhlexStorybook::Props::Text.new(key: :html, placeholder: "HTML", required: true),
    ]
  end

  def self.component_stories
    [
      { title: "Short Doc", html: short_html },
      { title: "Long Doc", html: long_html },
    ]
  end

  def self.short_html
    <<~HTML
      <doctype html>
      <html>
        <head>
          <title>Sample HTML</title>
        </head>
        <body>
          <h1>Sample HTML</h1>
          <p>This is a sample HTML document.</p>
        </body>
      </html>
    HTML
  end

  def self.long_html
    list_items = 50.times.map { |i| "      <li class='li'>list item #{i + 1}</li>" }
    <<~HTML
      <doctype html>
      <html>
        <head>
          <title>Sample HTML</title>
          <style>
            .ul {
              display: flex;
              flex-direction: column;
              height: 15vh;
            }
            .li {
              margin: 0.5rem;
              display: flex-block;
            }
          </style>
        </head>
        <body>
          <h1>Sample HTML</h1>
          <ul class='ul'>
            #{list_items.first.strip}\n#{list_items[1..-1].join("\n")}
          </ul>
        </body>
      </html>
    HTML
  end

  def initialize(html:)
    @html = html
    @formatter = Rouge::Formatters::HTML.new(css_class: 'highlight')
    @lexer = Rouge::Lexers::HTML.new
  end

  def view_template
    style do
      <<~CSS.squish
        .rendered-results-preview, .raw-html {
          margin: 20px;
          padding: 10px;
          border: 1px solid #ccc;
          border-radius: 5px;
          background-color: #fff;
          overflow-x: auto;
        }
        .highlight {
          background-color: #f4f4f4;
          border: 1px dashed #ddd;
          font-family: Monaco, Consolas, monospace;
          font-size: 14px;
          white-space: pre-wrap;
        }
        .raw-html {
          white-space: pre-wrap; /* Maintains spacing and format */
          background-color: #f4f4f4;
          border: 1px dashed #ddd;
          font-family: Monaco, Consolas, monospace;
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
      h1(style: "font-family: Karla, sans-serif") { 'Raw HTML' }
      div(class: 'highlight') { unsafe_raw @formatter.format(@lexer.lex(@html)) }
    end
  end

end
