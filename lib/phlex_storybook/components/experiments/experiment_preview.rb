# frozen_string_literal: true

require 'digest'

module PhlexStorybook
  module Components
    module Experiments
      class ExperimentPreview < ApplicationView
        def initialize(name:)
          @name = name
        end

        def view_template
          turbo_frame_tag("experiment_preview") do
            div(class: "text-xs bg-slate-500 text-slate-100 w-full p-2") do
              path = PhlexStorybook.configuration.experiment @name
              "file: #{path}, md5: #{Digest::MD5.hexdigest(File.read(path))}"
            end
            div(class: "row-span-3 h-full w-full overflow-y-scroll overflow-x-hidden px-2") do
              iframe(src: helpers.preview_experiment_path(@name), class: "w-full h-full")
            end
          end
        end
      end
    end
  end
end
