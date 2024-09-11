# frozen_string_literal: true

module PhlexStorybook
  module Components
    module Experiments
      class ExperimentEditor < ApplicationView
        def initialize(name:)
          @name = name
        end

        def view_template
          div id: "source", class: "h-full overflow-auto scroll", data: { code_editor_target: "editor" }
          textarea(class: "hidden", data: { copy_target: "source", code_editor_target: "ruby" }, name: "ruby") do
            source
          end
        end

        private

        def source
          File.read(PhlexStorybook.experiment(@name))
        end
      end
    end
  end
end
