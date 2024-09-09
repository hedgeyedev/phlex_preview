module PhlexStorybook
  module Props
    class String < Base
      def self.default = ""

      def view_template
        input(
          class: 'w-full text-slate-700',
          name: "props[#{hash_key}]",
          placeholder: placeholder,
          required: required,
          type: "text",
          value: value,
        )
      end
    end
  end
end
