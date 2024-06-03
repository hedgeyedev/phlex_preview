class PhlexPreviewApp < Phlex::HTML
  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new("Phlex Preview App", self, active: name == active_component_name)
  end

  def self.categories
    ["Meta Components"]
  end

  def initialize(phlex_code = nil, params = nil, **_kw_params)
    @phlex_code = phlex_code
    @params     = params
  end

  def view_template
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
        textarea(name: "code", id: :code) do
          @phlex_code || <<~RUBY
            #Type your Phlex component code here
            class HelloWorldComponent < Phlex::HTML
              attr_reader :user

              def initialize(user)
                @user = user
              end

              def view_template
                h1 { "Hello, \#{@user.name}" }
                div { "Email: \#{@user.email}" }
              end
            end
          RUBY
        end

        label(for: 'params') {"How to invoke your component(include necessary params):"}
        textarea(class: 'params', id: :params, name: "params") do
          @params || <<~RUBY
            # Example:
            require 'ostruct'
            HelloWorldComponent.new(OpenStruct.new(name: 'John Doe', email: 'jdoe@example.org'))
          RUBY
        end

        button( type: "submit") { "Render"}
      end
    end

    div(class: "section output-pane") do
      h2 {"Preview:"}
      iframe name: "preview_frame", srcdoc: "Your rendered output will appear here..."
    end
  end
end
