# frozen_string_literal: true

module PhlexStorybook
  module Components
    class Icon < ApplicationView
      def initialize(icon_class, inactive_class = nil, active: false)
        @icon_class = inactive_class && !active ? inactive_class : icon_class
        @active     = active
      end

      def view_template
        render Phlex::Icons::Lucide.const_get(@icon_class).new(classes: "#{icon_color} size-4 inline")
      end

      private

      def icon_color
        @active ? 'stroke-sky-500' : 'stroke-slate-300'
      end
    end
  end
end
