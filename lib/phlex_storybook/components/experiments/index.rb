# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Experiments
      class Index < ApplicationView
        def initialize(selected: nil)
          @story_components = PhlexStorybook.configuration.components
          @selected         = selected
        end

        def view_template
          turbo_frame_tag("story_components") do
            div class: "flex h-screen w-screen" do
              div class: "flex-none w-1/4 min-w-40 max-w-80 bg-slate-700 text-white story-selector" do
                render Stories::ComponentSelector.new(story_components: @story_components)
              end

              div class: "flex-auto h-full w-3/4 bg-white" do
                render ExperimentDisplay.new(name: @selected)
              end
            end
          end
        end
      end
    end
  end
end
