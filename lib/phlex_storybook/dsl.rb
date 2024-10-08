# frozen_string_literal: true

require "active_support/concern"

module PhlexStorybook
  module DSL
    extend ActiveSupport::Concern

    class Proxy
      def initialize(klass)
        @klass           = klass
        @story_component = PhlexStorybook.configuration.components[klass]
      end

      def category(v)
        @story_component.category = v
      end

      def description(v)
        @story_component.description = v
      end

      def lookup_prop_class(name)
        PhlexStorybook::Props.const_get(name.to_s.sub('prop_', '').camelize)
      end

      def prop(prop_class, key_or_position, **options)
        key = key_or_position.is_a?(Integer) ? nil : key_or_position
        position = key_or_position.is_a?(Integer) ? key_or_position : nil
        @story_component.props << prop_class.new(key: key&.to_sym, position: position, **options)
      end

      def story(k, *args, **kwargs)
        @story_component.stories[k] = args.map.with_index.with_object(kwargs) do |(arg, i), h|
          h[i] = arg
        end
      end

      private

      def method_missing(name, *args, **kw_args, &block)
        if @klass.respond_to?(name)
          return @klass.send(name, *args, **kw_args, &block)
        end

        return super unless name.start_with?('prop_')

        prop_class = lookup_prop_class(name)
        if prop_class
          prop(prop_class, args.first, **kw_args)
        else
          raise ArgumentError, "Unknown prop type: #{name}"
        end
      end

      def respond_to_missing?(name, include_private = false)
        return true if @klass.respond_to_missing?(name, include_private)
        return false unless name.start_with?('prop_')

        !!lookup_prop_class(name) || super
      end
    end

    class_methods do
      def storybook(&block)
        source_location = block&.source_location || self.instance_method(:view_template)&.source_location
        PhlexStorybook.configuration.register(self, source_location)
        Proxy.new(self).instance_eval(&block) if block
      end
    end
  end
end
