class SampleView < Phlex::HTML
  include Phlex::Rails::Layout
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag

  def view_template(&)
    doctype

    html lang: "en" do
      head do
        meta charset: "UTF-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1.0"
        title { "View: #{self.class.name}" }
        javascript_include_tag "https://cdn.tailwindcss.com"
        csrf_meta_tags
        csp_meta_tag
      end
      body do
        script(type: "module") { raw safe js }
        style { raw safe css }
        div(data: { controller: "test" }) do
          h1 { "Hello World" }
          # render MyComponent.new
        end
      end
    end
  end

  private

  def css
    <<~CSS
      .foo {
        color: red;
      }
    CSS
  end

  def js
    <<~JAVASCRIPT
      import { Application, Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"
      const application = Application.start()
      window.Stimulus = application

      class TestController extends Controller {
        connect() {
          document.body.insertAdjacentHTML("beforeend", '<div class="foo">Hello from Stimulus!</div>')
        }
      }

      application.register("test", TestController)
    JAVASCRIPT
  end
end

render SampleView.new, layout: false
