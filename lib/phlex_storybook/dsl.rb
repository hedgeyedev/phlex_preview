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

      def name(v)
        @story_component.name = v
      end

      def prop(prop_class, key, **options)
        @story_component.props << prop_class.new(key: key, **options)
      end

      def story(k, **props)
        @story_component.stories[k] = props
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
        PhlexStorybook.configuration.register(self, source_location).tap { |sc| sc.name = name }

        Proxy.new(self).instance_eval(&block) if block
      end
    end
  end
end
