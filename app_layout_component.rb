require 'phlex'

class AppLayoutComponent < Phlex::HTML
  def view_template
    html do
      head do
        title { "Phlex Preview App" }
        style {"textarea, iframe { width: 100%; height: 200px; margin-bottom: 20px; }"}
      end

      body do
        h1 {"Phlex Preview App"}

        form action: "/render", method: "post", target: "preview_frame" do
          label{ "Phlex Code:"}
          textarea name: "code", placeholder: "Type your Phlex component code here..."

          label{"Invocation Parameters (comma-separated):"} 
          input type: "text", name: "params", placeholder: "e.g., 'Hello', 123"

          button( type: "submit") { "Render"}
        end

        h2 {"Preview:"}
        iframe name: "preview_frame", srcdoc: "Your rendered output will appear here..."
      end
    end
  end
end
