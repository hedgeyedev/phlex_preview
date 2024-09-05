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
          turbo_frame_tag("story-rendering") do
            div(data: { story_display_target: "preview" }) do
              render @story_component.component.new(**@props)
            end

            div(
              class: "hidden mt-4 w-full",
              data: { story_display_target: "code" },
            ) do
              div(id: "component-code", class: "p-2 overflow-auto scroll") do
                source = @props.blank? ? "render #{@story_component.component.name}.new" : <<~RUBY.strip
                  render #{@story_component.component.name}.new(
                    #{@props.map { |k, v| "#{k}: #{v.inspect}," }.join("\n  ")}
                  )
                RUBY
                pre(class: "hidden", data: { copy_target: "source" }) { source }
                formatter = Rouge::Formatters::HTMLLineTable.new(Rouge::Formatters::HTML.new)
                lexer = Rouge::Lexers::Ruby.new
                unsafe_raw formatter.format(lexer.lex(source))
              end
              style do
                unsafe_raw Rouge::Themes::Molokai.render(scope: '#component-code')
              end
            end
          end
        end
      end
    end
  end
end
