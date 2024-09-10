# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Experiments
      class ExperimentDisplay < ApplicationView
        # include Phlex::Rails::Helpers::IframeTag

        def initialize(name:)
          @name = name
        end

        def view_template
          unless PhlexStorybook.configuration.experiment(@name)
            turbo_frame_tag("experiment_display") do
              blank_template
            end
            return
          end

          turbo_frame_tag("experiment_display") do
            div(class: "flex flex-col h-screen max-h-screen", data: { controller: "story-display copy" }) do
              render_header @name
              div(class: "px-2 flex-1 overflow-y-scroll overflow-x-hidden") do
                iframe(src: helpers.preview_experiment_path(@name), class: "w-full h-full")
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
          h2(class: "bg-slate-900 text-white border-x border-slate-700 p-2 flex-none") { text }
        end
      end
    end
  end
end
