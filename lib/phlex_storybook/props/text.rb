module PhlexStorybook
  module Props
    class Text < String
      def self.default = ""

      def view_template
        textarea(
          class: 'w-full text-slate-700',
          name: "props[#{key}]",
          placeholder: placeholder,
          required: required,
          rows: 5,
        ) { value }
      end
    end
  end
end
