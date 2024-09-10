# frozen_string_literal: true

module PhlexStorybook
  class StoriesController < ApplicationController
    layout -> { Layouts::ApplicationLayout }

    def index
      respond_to do |format|
        format.html { render Components::Stories::Index.new(story_components: story_components) }
      end
    end

    def show
      respond_to do |format|
        format.html do
          story_id = params[:story_id]
          render Components::Stories::Index.new(
            story_components: story_components,
            selected: story_component,
            selected_story: story_id,
          )
        end
      end
    end

    def update
      respond_to do |format|
        format.turbo_stream do
          story_id = params[:story_id]
          render turbo_stream: [
            turbo_stream.replace(
              "component_display",
              Components::Stories::ComponentDisplay.new(
                story_component: story_component,
                story_id: story_id,
                **story_component.transform_props(params[:props].permit!.to_h),
              ),
            )
          ]
        end
      end
    end

    private

    def story_components
      @story_components ||= PhlexStorybook.configuration.components
    end

    def story_component
      story_components.detect { |_k, e| e.name == params[:id] }&.last
    end
  end
end
