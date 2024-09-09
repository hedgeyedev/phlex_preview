module PhlexStorybook
  module Props
    class Select < Base
      attr_reader :include_blank, :multiple, :options

      def self.default = []

      def initialize(key:, options:, include_blank: false, multiple: false, **base_opts)
        super(key: key, **base_opts)
        @include_blank = include_blank
        @multiple = multiple
        @options = options
      end

      def view_template
        select(
          class: 'w-full text-slate-700',
          name: name,
          required: required,
          multiple: multiple,
        ) do
          option(value: "", selected: Array(value).empty?) { "Select..." } if include_blank
          options.each do |option|
            option(value: option, selected: Array(value).include?(option)) { option }
          end
        end
      end

      def name
        return "props[#{key}]" unless multiple

        "props[#{key}][]"
      end
    end
  end
end
