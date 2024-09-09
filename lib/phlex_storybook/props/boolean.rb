module PhlexStorybook
  module Props
    class Boolean < Base
      def self.default = false

      def transform(value)
        value == true || Array(value).include?("1")
      end

      def view_template
        check_box(
          "props[#{hash_key}]",
          nil,
          required: required,
          checked: value,
        )
      end
    end
  end
end
