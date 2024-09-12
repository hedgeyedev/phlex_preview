# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Experiments
      class ExperimentDisplay < ApplicationView
        def initialize(name:)
          @name = name
        end

        def view_template
          unless PhlexStorybook.experiment(@name)
            turbo_frame_tag("experiment_display") do
              blank_template
            end
            return
          end

          turbo_frame_tag("experiment_display") do
            form(data: { turbo_streams: true }, method: "PUT", action: helpers.experiment_path(@name)) do
              div(class: "flex flex-col h-screen max-h-screen w-full", data: { controller: "code-editor" }) do
                render_header @name

                div(class: "grid grid-flow-row grid-rows-12 h-full w-full px-0") do
                  div(class: "row-span-6 overflow-x-hidden") do
                    render ExperimentEditor.new(name: @name)
                  end

                  div(class: "row-span-5 overflow-x-hidden") do
                    render ExperimentPreview.new(name: @name)
                  end
                end
              end
            end
          end
        end

        private

        def blank_template
          render_header("Select a component")
          div(class: "px-2") { "Select an experiment from the left to see its preview" }
        end

        def render_header(text)
          path = PhlexStorybook.experiment(@name).sub("#{Rails.root.to_s}/", "")
          h2(class: "flex justify-between items-center bg-slate-900 text-white border-x border-slate-700 p-2 flex-none") do
            div { text.classify }
            div(class: "text-xs text-slate-200") { path }
            div do
              button(
                class: "pr-2 opacity-70 hover:opacity-100 hover:cursor-pointer",
                data: { action: "click->code-editor#saveSource" }
              ) { render Icon.new(:Save, size: :md) }
            end
          end
        end
      end
    end
  end
end
