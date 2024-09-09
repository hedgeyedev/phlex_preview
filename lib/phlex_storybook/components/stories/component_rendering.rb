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
          initializer = PhlexStorybook::Props::ComponentInitializer.create(@story_component, **@props)
          turbo_frame_tag("story-rendering") do
            div(data: { story_display_target: "preview" }) do
              render initializer.initialize_component(@story_component.component)
            end

            args = @props.blank? ? "" : "(#{initializer.parameters_as_string}\n)"
            source = "render #{@story_component.component.name}.new#{args}".strip

            render_ruby_code "code", source
            render_ruby_code "source", @story_component.source
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
              unsafe_raw formatter.format(lexer.lex(source))
            end
            style do
              unsafe_raw Rouge::Themes::Molokai.render(scope: "##{id}")
            end
          end
        end
      end
    end
  end
end
