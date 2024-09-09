module PhlexStorybook
  module Props
    class Base < ApplicationView
      attr_reader :default, :key, :label, :placeholder, :required, :value

      def initialize(key:, default: nil, label: nil, placeholder: nil, required: false)
        @key         = key
        @default     = default
        @label       = label || key.to_s.humanize.split.map(&:capitalize).join(" ")
        @placeholder = placeholder
        @required    = !!required
        @value       = nil
      end

      def transform(value)
        value.blank? ? default : value
      end

      def view_template(&block)
        raise "Subclass responsibility"
      end

      def clone_with_value(v)
        p = dup
        p.instance_variable_set(:@value, v)
        p
      end
    end
  end
end
