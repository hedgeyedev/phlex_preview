# frozen_string_literal: true

module PhlexStorybook
  class ExperimentsController < ApplicationController
    before_action :reject_unless_editable!

    layout -> { turbo_frame_request? ? false : Layouts::ApplicationLayout }

    def create
      PhlexStorybook.create_experiment!(experiment_name)
      redirect_to experiment_path(experiment_name.downcase)
    end

    def destroy
      File.delete(experiment)
      redirect_to root_path
    end

    def new
      respond_to do |format|
        format.html do
          render Components::Experiments::New.new
        end
      end
    end

    def preview
      respond_to do |format|
        format.html { eval File.read(experiment) }
      end
    end

    def show
      respond_to do |format|
        format.html do
          render Components::Experiments::Index.new(selected: experiment_name)
        end

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "experiment_display",
              Components::Experiments::ExperimentDisplay.new(name: experiment_name),
            ),
          ]
        end
      end
    end

    def update
      File.write(experiment, params[:ruby])

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "experiment_preview",
              Components::Experiments::ExperimentPreview.new(name: experiment_name),
            ),
          ]
        end
      end
    end

    private

    def experiment
      PhlexStorybook.experiment experiment_name
    end

    def experiment_name
      params[:id]
    end

    def reject_unless_editable!
      redirect_to root_path unless PhlexStorybook.configuration.editable?
    end
  end
end
