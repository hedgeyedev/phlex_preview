module PhlexStorybook
  module Props
    class Base < ApplicationView
      attr_reader :default, :key, :label, :placeholder, :position, :required, :value

      def self.default = nil

      def initialize(key: nil, position: nil, default: nil, label: nil, placeholder: nil, required: false)
        raise ArgumentError, "key or position is required" if key.nil? && position.nil?

        @key         = key&.to_sym
        @position    = position
        @default     = default
        @label       = label || default_label
        @placeholder = placeholder
        @required    = !!required
        @value       = nil
      end

      def add_to(initializer)
        if positional?
          initializer.positional_arguments[position.to_i] = transform(value)
        else
          initializer.keyword_arguments[key.to_sym] = transform(value)
        end
      end

      def clone_from(hash)
        clone_with_value(hash&.fetch(position, hash&.fetch(key, nil)))
      end

      def clone_with_value(v)
        p = dup
        p.instance_variable_set(:@value, v)
        p
      end

      def hash_key
        positional? ? position : key
      end

      def keyword?
        !!@key
      end

      def positional?
        !!@position
      end

      def prop_for?(key)
        return true if positional? && key.to_s == position.to_s
        return false if positional?

        self.key == key.try(:to_sym)
      end

      def transform(value)
        value.blank? && value != false ? default : value
      end

      def view_template(&block)
        raise NotImplementedError, "Subclass responsibility"
      end

      private

      def default_label
        return key.to_s.humanize.split.map(&:capitalize).join(" ") if keyword?
        "Positional Argument: #{position}"
      end
    end
  end
end
