# frozen_string_literal: true

class AppLayoutComponent < ApplicationComponent
  class Blank < Phlex::HTML
    def initialize(*_args, **_kwargs)
      # no-op
    end

    def view_template
      div { "No component selected" }
    end
  end

  class NoExplanation < Phlex::HTML
    def view_template
      div { "No explanation available" }
    end
  end

  def initialize(component_name, *component_args, explanatory_component: nil, **component_kwargs, &component_blk)
    @component_name        = component_name || "AppLayoutComponent::Blank"
    @component_args        = component_args
    @component_kwargs      = component_kwargs
    @component_blk         = component_blk
    @explanatory_component = explanatory_component || "#{@component_name}Explanation"
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

        h1 {
          color: #333;
          font-size: 24px;
        }

        textarea, iframe { width: 100%; height: 500px; margin-bottom: 20px; }

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

        .storybook {
          display: grid;
          height: 90vh;
          width: 98vw;
          grid-template-columns: 1fr 4fr;
          grid-gap: 5px;
          margin: 0 auto;
        }

        .sidebar {
          width: 100%;
          border-right: 1px solid #ddd;
        }
        .sidebar > .section {
          margin: 5px 3px;
          border-bottom: 1px solid #ddd;
        }
        .component-selection > a {
          font-size: 0.75rem;
          text-decoration: none;
        }
        .component-selection > a:visited {
          color: rgb(0, 0, 238)
        }

        .container {
          width: 80vw;
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

        .section {
          background: white;
          border: 1px solid #ddd;
          padding: 15px;
          margin-top: 20px;
          border-radius: 4px;
        }

        .output-pane {
          background-color: #f4f4f4;
          border: 1px solid #ccc;
          padding: 10px;
          margin-top: 20px;
          overflow-x: auto;
          white-space: pre-wrap; /* Ensures that spaces and line breaks are respected */
        }

        .params { height: 100px; margin-bottom: 20px; }
      CSS
    }
  end

  def component_code
    File.read File.join '.', 'components', "#{@component_name.underscore}.rb"
  end

  def view_template
    html(lang: "en") do
      head do
        meta(charset: "utf-8")
        title { "Phlex Preview App" }
        common_styles
        app_styles
        codemirror_includes
      end

      body do
        div(class: "storybook") do
          sidebar
          component_view do
            render (constantize(@explanatory_component) || NoExplanation).new
            hr
            div(id: "component_view") do
              render constantize(@component_name).new(*@component_args, **@component_kwargs, &@component_blk)
            end
            hr
            h1 { "Component Code" }
            textarea(id: 'component_code') { component_code }
          end
        end
        codemirror_attach
      end
    end
  end

  def codemirror_attach
    script do
      unsafe_raw <<~JS
        document.addEventListener("DOMContentLoaded", function() {
          const code           = document.getElementById('code'),
                params         = document.getElementById('params'),
                component_code = document.getElementById('component_code');

          [code, params, component_code].forEach((el) => {
            if (!el) return;

            CodeMirror.fromTextArea(el, {
              lineNumbers: true,
              mode: 'ruby',
              theme: 'default',
              foldGutter: true,
              indentUnit: 2,
              tabSize: 2,
              indentWithTabs: false
            });
          });
        });
      JS
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
    style do
      unsafe_raw <<~CSS
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

      #component_code + .CodeMirror {
        height: 500px !important; /* Separate rule to set a different height */
      }
      CSS
    end
  end

  def component_view(&)
    div(class: "container", &)
  end

  def sidebar
    div(class: "sidebar") do
      div(class: "section") do
        strong { "Meta Components" }
        render ComponentSelector.new("Phlex Preview App", PhlexPreviewApp)
      end

      div(class: "section") do
        strong { "Input Components" }
        render ComponentSelector.new(
          "Labelized Checkbox",
          LabelizedCheckbox,
          kw_args: {label: "Checkbox Label", name: "checkbox_name", left: true},
        )
        render ComponentSelector.new(
          "Labelized Text Input",
          LabelizedInput,
          kw_args: {label: "Text Input Label", name: "input_name", type: "text"},
        )
        render ComponentSelector.new(
          "Labelized Date Input",
          LabelizedDateInput,
          LabelizedMagnitudeExplanation,
          kw_args: {label: "Date Input Label", name: "input_name"},
        )
        render ComponentSelector.new(
          "Labelized Date/Time Input",
          LabelizedDateTimeInput,
          LabelizedMagnitudeExplanation,
          kw_args: {label: "Date/Time Input Label", name: "input_name"},
        )
        render ComponentSelector.new(
          "Labelized Number Input",
          LabelizedNumberInput,
          LabelizedMagnitudeExplanation,
          kw_args: {label: "Number Input Label", name: "input_name"},
        )
        render ComponentSelector.new(
          "Labelized Time Input",
          LabelizedTimeInput,
          LabelizedMagnitudeExplanation,
          kw_args: {label: "Time Input Label", name: "input_name", min: "09:00", max: "17:00"},
        )
      end
    end
  end

  private

  # judiciously copied from ActiveSupport::Inflector
  def constantize(camel_cased_word)
    if camel_cased_word.nil? || camel_cased_word.empty? || !camel_cased_word.include?("::")
      Object.const_get(camel_cased_word)
    else
      names = camel_cased_word.split("::")

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end
  rescue NameError
    nil
  end
end

# Sample invocation:
# code = <<~RUBY
# class UserProfileComponent < Phlex::HTML
#   def initialize(user)
#     @user = user
#   end

#   def view_template
#     div {
#       h1 { @user.name }
#       p { @user.email }
#     }
#   end
# end
# RUBY
# params = <<~RUBY
# user = Object.new
# def user.name = 'John Doe'
# def user.email = 'john@example.com'
# RUBY
# AppLayoutComponent.new(code, params)
# End Sample invocation
