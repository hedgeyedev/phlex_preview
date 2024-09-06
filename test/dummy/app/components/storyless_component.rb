# frozen_string_literal: true

class StorylessComponent < Phlex::HTML
  include PhlexStorybook::DSL

  register_component do
    component_category "Category 1"
    component_description "This is a storyless component"
    component_name "Component without stories"
    component_props [
      PhlexStorybook::Props::String.new(key: :header, default: "Default Header", required: true),
      PhlexStorybook::Props::Text.new(key: :text, label: "The list"),
    ]
  end

  def initialize(header:, text: "ant\nbat\ncat\ndog")
    @text  = text || ""
    @header = header
  end

  def view_template
    h1 { @header }
    pre { @text }
  end
end
