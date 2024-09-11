# frozen_string_literal: true

module PhlexStorybook
  module Components
    class Icon < ApplicationView
      SIZES = {
        sm: "size-4",
        md: "size-6",
        lg: "size-8",
      }

      def initialize(icon_class, inactive_class = nil, active: false, size: nil)
        @active     = active
        @icon_class = inactive_class && !active ? inactive_class : icon_class
        @size       = size || :sm
      end

      def view_template
        render Phlex::Icons::Lucide.const_get(@icon_class).new(classes: "#{icon_color} #{SIZES[@size]} inline")
      end

      private

      def icon_color
        @active ? 'stroke-sky-500' : 'stroke-slate-300'
      end
    end
  end
end
