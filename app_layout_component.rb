require 'phlex'

class AppLayoutComponent < ApplicationComponent
  def initialize(phlex_code, params)
    @phlex_code = phlex_code
    @params = params
  end

  def app_styles
    style {
      unsafe_raw <<~CSS

body, html {
  font-family: 'Helvetica Neue', Arial, sans-serif;
  margin: 0;
  padding: 0;
  background: #f9f9f9;
  color: #333;
}

.container {
  width: 90%;
  margin: 0 auto;
  padding: 20px;
}

.textarea {
  width: 100%;
  height: 500px;
  margin-top: 10px;
  padding: 8px;
  box-sizing: border-box;
  border: 1px solid #ccc;
  border-radius: 4px;
  resize: none;
  background-color: #fff;
  font-family: 'Courier New', monospace;
}

button {
  padding: 10px 20px;
  margin-top: 10px;
  border: none;
  border-radius: 4px;
  background-color: #007BFF;
  color: white;
  cursor: pointer;
  font-size: 16px;
}

button:hover {
  background-color: #0056b3;
}

.section {
  background: white;
  border: 1px solid #ddd;
  padding: 15px;
  margin-top: 20px;
  border-radius: 4px;
}

h1 {
  color: #333;
  font-size: 24px;
}

.output-pane {
  background-color: #f4f4f4;
  border: 1px solid #ccc;
  padding: 10px;
  margin-top: 20px;
  overflow-x: auto;
  white-space: pre-wrap; /* Ensures that spaces and line breaks are respected */
}
textarea, iframe { width: 100%; height: 500px; margin-bottom: 20px; }
.params { height: 100px; margin-bottom: 20px; }

CSS
    }
  end
  def view_template
    html do
      head do
        title { "Phlex Preview App" }
        common_styles
        app_styles
        codemirror_includes
      end

      body do
        div(class: "container") do 
          form(action: "/load", method: "post", enctype: "multipart/form-data") do
            whitespace
            input(type: "file", name: "file", accept: ".rb")
            whitespace
            button(type: "submit") { "Load Phlex Component" }
          end
          h1 {"Phlex Preview App"}
          div(class: "section") do

            form action: "/render", method: "post", target: "preview_frame" do
              label(for: 'code') { "Phlex Code:"}
              textarea( name: "code", id: :code, placeholder: "#Type your Phlex component code here...\nclass YourComponent < Phlex::HTML\n  ...") { @phlex_code }
              
              label(for: 'params') {"How to invoke your component(include necessary params):"}
              textarea(class: 'params', id: :params, name: "params", placeholder: "e.g., UserProfileComponent(User.new(name: 'John Doe'))") { @params }
              
              button( type: "submit") { "Render"}
            end
          end

          div(class: 'section output-pane') do
            h2 {"Preview:"}
            iframe name: "preview_frame", srcdoc: "Your rendered output will appear here..."
          end
        end
        codemirror_attach
      end
    end
  end

  def codemirror_includes
    
    comment { "CodeMirror CSS" }
    link(
      rel: "stylesheet",
      href:
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css"
    ) 

    comment { "CodeMirror JavaScript Library" }
    script(
      src:
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"
    )

    comment { "Ruby mode" }
    script(
      src:
        "https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/ruby/ruby.min.js"
    )
    style { unsafe_raw <<~CSS
/* Basic styling for CodeMirror */
.CodeMirror {
    border: 1px solid #ccc;  /* Adds a light grey border around the editor */
    padding: 10px;           /* Adds padding inside the editor for better text alignment */
    background-color: #f7f7f7; /* A light background color */
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas', 'source-code-pro', monospace;
    height: auto;            /* Adjust height as needed */
    min-height: 200px;       /* Minimum height to ensure sufficient editing space */
}

/* Specific styling for focused editor */
.CodeMirror-focused {
    border-color: #blue; /* Highlight border when editor is focused */
    box-shadow: 0 0 5px rgba(81, 203, 238, 1); /* Soft blue glow around editor */
}


#code + .CodeMirror, #invocation-textarea + .CodeMirror {
  height: 500px !important; /* Use !important to override any inline styles */
}

#params + .CodeMirror {
  height: 100px !important; /* Separate rule to set a different height */
}

CSS
    }
    end

  def codemirror_attach
    script do
      unsafe_raw <<~JS
        document.addEventListener("DOMContentLoaded", function() {
          CodeMirror.fromTextArea(document.getElementById('code'), {
            lineNumbers: true,
            mode: 'ruby',
            theme: 'default',
            foldGutter: true,
            indentUnit: 2,
            tabSize: 2,
            indentWithTabs: false
          });

          CodeMirror.fromTextArea(document.getElementById('params'), {
            lineNumbers: true,
            mode: 'ruby',
            theme: 'default',
            indentUnit: 2,
            tabSize: 2,
            indentWithTabs: false
          });
        });
      JS
    end
  end
end

# Sample invocation:

# code = "class UserProfileComponent < Phlex::HTML\n  def initialize(user)\n    @user = user\n  end\n\n  def view_template\n    div {\n      h1 { @user.name }\n      p { @user.email }\n    }\n  end\nend"
# params = "UserProfileComponent.new(User.new('John Doe', 'john@example.com')) "
# AppLayoutComponent.new(code, params)
# End Sample invocation
