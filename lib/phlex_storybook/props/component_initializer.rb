# frozen_string_literal: true

module PhlexStorybook
  module Props

    class ComponentInitializer
      attr_reader :positional_arguments, :keyword_arguments

      def self.create(story_component, **props)
        instance = new
        props.each do |k, v|
          story_component.props.find { |p| p.prop_for?(k) }&.clone_with_value(v)&.add_to(instance)
        end
        instance
      end

      def initialize
        @positional_arguments = []
        @keyword_arguments = {}
      end

      def initialize_component(klass)
        klass.new(*positional_arguments, **keyword_arguments)
      end

      def parameters_as_string
        args = [
          positional_arguments.map(&:inspect),
          keyword_arguments.map { |k, v| "#{k}: #{v.inspect}" }
        ].reject(&:empty?).flatten
        return "" if args.empty?

        "\n  #{args.join(",\n  ")},"
      end
    end
  end
end
