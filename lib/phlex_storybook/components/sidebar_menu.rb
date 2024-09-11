# frozen_string_literal: true

module PhlexStorybook
  module Components
    class SidebarMenu < ApplicationView
      def initialize(story_components:, selected: nil, selected_story: nil)
        @story_components_by_category = story_components.values.group_by(&:category).sort
        @selected                     = selected
        @selected_story               = selected_story
      end

      def view_template
        turbo_frame_tag("sidebar_menu") do
          h2(class: "bg-slate-900 p-2") { "Components" }
          div(class: "px-2") do
            render_experiments

            @story_components_by_category.each do |category, story_components|
              h4 { category }
              ul do
                story_components.each do |story_component|
                  li do
                    component_link(story_component)

                    if story_component.stories.present?
                      ul do
                        story_component.stories&.keys&.each do |title|
                          li(class: "pl-4 text-sm") { story_link(story_component, title) }
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
          data: { turbo_frame: "_top" },
          href: helpers.story_path(story_component.name),
          class: "#{active ? active_selection : ''}",
        ) do
          span(class: "pr-1") do
            render Icon.new(:Component, active: active)
          end
          span { story_component.name }
        end
      end

      def render_experiments
        a(data: { turbo_frame: "_top" }) do
          h4(class: "inline-block") { "Experiments" }
        end

        ul do
          li do
            a do
              span(class: "pr-1") do
                render Icon.new(:FilePlus2)
              end
              span { "create new" }
            end
          end
          PhlexStorybook.configuration.experiments.each do |experiment|
            li do
              name = File.basename(experiment, ".rb")
              active = name == @selected
              a(
                href: helpers.experiment_path(name),
                data: { turbo_frame: "_top" },
                class: "#{active ? active_selection : ''}",
              ) do
                span(class: "pr-1") do
                  render Icon.new(:Codesandbox, active: active)
                end
                span { name.classify }
              end
            end
          end
        end
      end

      def story_link(story_component, title)
        id     = story_component.id_for(title)
        active = id == @selected_story

        a(
          class: "#{active ? active_selection : ''}",
          href: helpers.story_path(story_component, story_id: id),
          data: { turbo_frame: "_top" },
        ) do
          span(class: "pr-1") { render Icon.new(:NotebookText, :Notebook, active: active) }
          span { "#{title}"}
        end
      end
    end
  end
end
