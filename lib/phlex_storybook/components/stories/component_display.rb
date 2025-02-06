# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Stories
      class ComponentDisplay < ApplicationView
        def initialize(story_component:, story_id: nil, **props)
          @story_component = story_component
          @story_id        = story_id
          @props           = props
        end

        def view_template
          if @story_component.nil?
            turbo_frame_tag("component_display") do
              blank_template
            end
            return
          end

          turbo_frame_tag("component_display") do
            div(class: "flex flex-col h-screen max-h-screen", data: { controller: "story-display copy" }) do
              render_header @story_component.name
              div(class: "px-2 flex-1 overflow-y-scroll overflow-x-hidden") do
                props = @props.blank? ? @story_component.story_for(@story_id) : @props
                if @story_id && props.nil?
                  h1 { "Story not found" }
                  next
                end

                div(class: "mb-4") { @story_component.description }

                div(class: "w-full h-fit min-w-0 mr-0") do
                  render_story_header
                  render ComponentRendering.new(
                    story_component: @story_component,
                    story_id: @story_id,
                    **@story_component.default_story.merge(props || {}),
                  )
                end
              end
            end
          end
        end

        private

        def blank_template
          render_header("Select a component")
          div(class: "px-2") do
            if PhlexStorybook.configuration.editable?
              "Select a component or experiment from the left to see its details"
            else
              "Select a component from the left to see its details"
            end
          end
        end

        def render_header(text)
          h2(class: "bg-slate-900 text-white border-x border-slate-700 p-2 flex-none") { text }
        end

        def render_story_header
          div(class: "flex justify-between") do
            ul(class: "text-sm text-white inline-flex bg-slate-700 rounded border-slate-200") do
              li(
                class: "relative px-3 py-2 flex-grow-1 story-button-active",
                data: {
                  action: "click->story-display#showPreview click->copy#disable:prevent",
                  story_display_target: "previewBtn",
                },
              ) do
                button(class: "font-semibold") { "Preview" }
              end

              li(
                class: "relative px-3 py-2 flex-grow-1",
                data: {
                  action: 'click->story-display#showCode click->copy#enable:prevent',
                  story_display_target: 'codeBtn',
                },
              ) do
                button(class: "font-semibold") { "Ruby Code" }
              end

              li(
                class: "relative px-3 py-2 flex-grow-1",
                data: {
                  action: 'click->story-display#showComponentSource click->copy#disable:prevent',
                  story_display_target: 'sourceBtn',
                },
              ) do
                button(class: "font-semibold") { "Component Source" }
              end
            end
            button(
              disabled: true,
              data: { copy_target: "btn", action: "click->copy#copy" },
              class: "bg-slate-700 group px-2 py-1 rounded",
            ) do
              span(class: 'clipboard') do
                render PhlexIcons::Lucide::Copy.new(
                  class: "group-enabled:stroke-slate-100 group-disabled:stroke-slate-500 size-5",
                )
              end
              span(class: 'check hidden') do
                render PhlexIcons::Lucide::CopyCheck.new(class: "stroke-green-400 size-5")
              end
            end
          end
        end
      end
    end
  end
end
