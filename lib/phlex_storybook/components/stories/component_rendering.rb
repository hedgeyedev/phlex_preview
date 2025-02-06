# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Stories
      class ComponentRendering < ApplicationView
        def initialize(story_component:, story_id: nil, **props)
          @story_component = story_component
          @story_id        = story_id
          @props           = props.blank? ? story_component.default_story : props
        end

        def view_template
          component_instance, component_source = @story_component.evaluate!(**@props)

          turbo_frame_tag("story-rendering") do
            div(data: { story_display_target: "preview" }) do
              render component_instance
            end

            render_ruby_code "code", component_source

            div(class: "hidden mt-4 w-full", data: { story_display_target: "source" }) do
              if PhlexStorybook.configuration.editable?
                action = helpers.component_path(@story_component, story_id: @story_id)
                form(action: action, method: "PUT") do
                  render_component_source

                  div(class: "hidden") { @story_component.props.each { |prop| render prop.clone_from(@props) } }

                  button(
                    class: "mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded",
                    data: { action: "click->story-display#saveComponentSource" },
                  ) { "Save" }
                end
              else
                render_component_source
              end
            end
          end
        end

        private

        def render_component_source
          div id: "source", class: "p-2 overflow-auto scroll", data: { story_display_target: "editor" }
          textarea(class: "hidden", data: { story_display_target: "ruby" }, name: "ruby") do
            @story_component.source
          end
        end

        def render_ruby_code(id, source)
          div(
            class: "hidden mt-4 w-full",
            data: { story_display_target: id },
          ) do
            div(id: id, class: "p-2 overflow-auto scroll") do
              pre(class: "hidden", data: { copy_target: "source" }) { source }
              formatter = Rouge::Formatters::HTMLLineTable.new(Rouge::Formatters::HTML.new)
              lexer = Rouge::Lexers::Ruby.new
              raw safe formatter.format(lexer.lex(source))
            end
            style do
              raw safe Rouge::Themes::Molokai.render(scope: "##{id}")
            end
          end
        end
      end
    end
  end
end
