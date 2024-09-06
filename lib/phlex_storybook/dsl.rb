# frozen_string_literal: true

require "active_support/concern"

module PhlexStorybook
  module DSL
    extend ActiveSupport::Concern

    class_methods do
      def __find_registered__
        PhlexStorybook.configuration.components[self]
      end

      def component_category(v)
        __find_registered__.category = v
      end

      def component_description(v)
        __find_registered__.description = v
      end

      def component_name(v)
        __find_registered__.name = v
      end

      def component_props(v)
        __find_registered__.props = v
      end

      def component_stories(v)
        __find_registered__.stories = v
      end

      def register_component(&block)
        PhlexStorybook.configuration.register(self, block.source_location).tap { |sc| sc.name = name }
        block.call
      end
    end
  end
end
