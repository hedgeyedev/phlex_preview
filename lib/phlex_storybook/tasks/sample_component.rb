class SampleComponent < Phlex::HTML
  def view_template(&)
    script(type: "module") { raw safe js }
    style { raw safe css }
    div(data: { controller: "test" }) do
      h1 { "Hello World" }
      # render MyComponent.new
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

render SampleComponent.new, layout: false
