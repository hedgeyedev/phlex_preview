# frozen_string_literal: true

module PhlexStorybook
  class ExperimentsController < ApplicationController
    before_action :reject_unless_editable!

    layout -> { Layouts::ApplicationLayout }

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

    private

    def experiment
      PhlexStorybook.configuration.experiment experiment_name
    end

    def experiment_name
      params[:id]
    end

    def reject_unless_editable!
      redirect_to root_path unless PhlexStorybook.configuration.editable?
    end
  end
end
