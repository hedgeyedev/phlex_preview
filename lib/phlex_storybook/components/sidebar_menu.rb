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
          h2(class: "flex justify-between bg-slate-900 p-2") do
            div { "Components" }
            div do
              a(
                class: "pr-2 opacity-70 hover:opacity-100 hover:cursor-pointer",
                href: helpers.components_path,
                data: { turbo: "false" },
              ) { render Icon.new(:FolderSync, size: :md) }
            end
          end
          div(class: "px-2") do
            render_experiments if PhlexStorybook.configuration.editable?

            @story_components_by_category.each do |category, story_components|
              h4 { category }
              ul do
                story_components.each do |story_component|
                  li do
                    component_link(story_component)

                    if story_component.stories.present?
                      ul do
                        story_component.stories&.keys&.each do |title|
                          li(class: "spanner pl-4 text-sm") { story_link(story_component, title) }
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
          class: "spanner #{active ? active_selection : ''} text-ellipsis overflow-hidden whitespace-nowrap",
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
            form_tag(
              helpers.experiments_path,
              data: { turbo: "false", controller: "experiments" },
              method: "POST",
            ) do
              input(
                class: "!hidden w-full p-2 text-slate-700 rounded",
                data: {action: "keydown.esc->experiments#cancel"},
                name: "id",
                pattern: "^[a-zA-Z]+(::[a-zA-Z]+)*$",
                placeholder: "Experiment name (e.g. Foo)",
                type: "text",
              )
              a(class: "cursor-pointer", data: {action: "click->experiments#showInput"}) do
                span(class: "pr-1") { render Icon.new(:FilePlus2) }
                span { "create new" }
              end
            end
          end
          PhlexStorybook.experiments.each do |experiment|
            li do
              name = File.basename(experiment, ".rb")
              active = name == @selected
              span(class: "spanner flex justify-between") do
                a(
                  href: helpers.experiment_path(name),
                  data: { turbo_frame: "_top" },
                  class: "#{active ? active_selection : ''} w-full text-ellipsis overflow-hidden",
                ) do
                  span(class: "whitespace-nowrap") do
                    span(class: "pr-1") do
                      render Icon.new(:Codesandbox, active: active)
                    end
                    span { name.classify }
                  end
                end
                div(class: "pr-4") do
                  link_to(
                    helpers.experiment_path(name),
                    class: "cursor-pointer",
                    data: {turbo_method: :delete, turbo_confirm: "Are you sure?", turbo_frame: "_top"},
                  ) do
                    render Icon.new(:Trash2, classes: "hover:stroke-red-600")
                  end
                end
              end
            end
          end
        end
      end

      def story_link(story_component, title)
        id     = story_component.id_for(title)
        active = id == @selected_story

        a(
          class: "#{active ? active_selection : ''} text-ellipsis overflow-hidden whitespace-nowrap",
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
