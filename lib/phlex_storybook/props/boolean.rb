module PhlexStorybook
  module Props
    class Boolean < Base
      def self.default = false

      def transform(value)
        Array(value).include? "1"
      end

      def view_template
        check_box(
          "props[#{key}]",
          nil,
          required: required,
          checked: value,
        )
      end
    end
  end
end
