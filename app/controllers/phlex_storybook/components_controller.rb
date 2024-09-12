# frozen_string_literal: true

module PhlexStorybook
  class ComponentsController < ApplicationController

    def index
      PhlexStorybook.configuration.rescan!
      redirect_to root_path
    end

    def update
      respond_to do |format|
        format.turbo_stream do
          case story_component.update_source(params[:ruby])
          in {success: true}
            story_id = params[:story_id]
            redirect_to story_path(story_component, story_id: story_id)
          in {success: false, error:}
            render turbo_stream: [
              turbo_stream.replace(
                "saving",
                "error: #{error.message}",
              ),
            ]
          else
            # huh?!?!
          end
        end
      end
    end

    private

    def story_component
      PhlexStorybook.configuration.components.detect { |_k, e| e.name == params[:id] }&.last
    end
  end
end
