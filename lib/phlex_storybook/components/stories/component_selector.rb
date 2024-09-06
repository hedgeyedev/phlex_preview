# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Stories
      class ComponentSelector < ApplicationView
        def initialize(story_components:, selected: nil, selected_story: nil)
          @story_components_by_category = story_components.values.group_by(&:category).sort
          @selected                     = selected
          @selected_story               = selected_story
        end

        def view_template
          turbo_frame_tag("component_selector") do
            h2(class: "bg-slate-900 p-2") { "Components" }
            div(class: "px-2") do
              @story_components_by_category.each do |category, story_components|
                h4 { category }
                ul do
                  story_components.each do |story_component|
                    li do
                      component_link(story_component)

                      if story_component.stories.present?
                        ul do
                          story_component.stories&.each do |title, props|
                            li(class: "pl-4 text-sm") { story_link(story_component, title, props) }
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end

        private

        def active_selection
          'font-semibold text-sky-500'
        end

        def component_link(story_component)
          active = story_component == @selected
          a(
            data: { turbo_stream: true },
            href: helpers.story_path(story_component.name),
            class: "#{active ? active_selection : ''}",
          ) do
            span(class: "pr-1") do
              render Phlex::Icons::Lucide::Component.new(classes: "#{icon_color(active)} size-4 inline")
            end
            span { story_component.name }
          end
        end

        def icon_color(state)
          state ? 'stroke-sky-500' : 'stroke-slate-300'
        end

        def story_link(story_component, title, props)
          id     = story_component.id_for(title)
          active = id == @selected_story
          icon   = active ? Phlex::Icons::Lucide::NotebookText : Phlex::Icons::Lucide::Notebook

          a(
            class: "#{active ? active_selection : ''}",
            href: helpers.story_path(story_component, story_id: id),
            data: { turbo_stream: true },
          ) do
            span(class: "pr-1") { render icon.new(classes: "#{icon_color(active)} size-4 inline") }
            span { "#{title}"}
          end
        end
      end
    end
  end
end
