# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Stories
      class Index < ApplicationView
        def initialize(story_components:, selected: nil, selected_story: nil)
          @story_components = story_components
          @selected         = selected
          @selected_story   = selected_story
        end

        def view_template
          turbo_frame_tag("story_components") do
            div class: "flex h-screen w-screen" do
              div class: "flex-none w-1/4 min-w-40 max-w-80 bg-slate-700 text-white story-selector" do
                render ComponentSelector.new(story_components: @story_components, selected: @selected, selected_story: @selected_story)
              end

              div class: "flex-auto h-full w-1/2 bg-white" do
                render ComponentDisplay.new(story_component: @selected, story_id: @selected_story)
              end

              div class: "flex-none w-1/4 min-w-40 max-w-80 bg-slate-700 text-white" do
                render ComponentProperties.new(story_component: @selected, story_id: @selected_story)
              end
            end
          end
        end
      end
    end
  end
end
