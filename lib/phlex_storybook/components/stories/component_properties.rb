# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Stories
      class ComponentProperties < ApplicationView
        def initialize(story_component:, story_id: nil)
          @story_component = story_component
          @story_id        = story_id

          if story_id
            @props = story_component.story_for(story_id)
          end
        end

        def view_template
          if @story_component&.props.blank?
            turbo_frame_tag("component_properties") do
              h2(class: "bg-slate-900 p-2") { "Properties" }
              div(class: "px-2") { "No properties" }
            end
            return
          end

          turbo_frame_tag("component_properties") do
            h2(class: "bg-slate-900 p-2") { "Properties" }
            div(class: "px-2") do
              form(action: helpers.story_path(@story_component, story_id: @story_id), method: 'PUT') do
                ul do
                  @story_component.props.each do |prop|
                    li do
                      label(class: 'grid grid-cols-1 w-full') do
                        div { prop.label }
                        render prop.clone_from(@props)
                      end
                    end
                  end
                end

                button(
                  type: "submit",
                  class: "mt-4 px-3 py-2 rounded-lg bg-slate-600 hover:ring-1 hover:ring-slate-100",
                ) { "« Render" }
              end
            end
          end
        end
      end
    end
  end
end
