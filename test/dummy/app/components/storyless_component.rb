# frozen_string_literal: true

class StorylessComponent < Phlex::HTML
  def self.component_category
    "Category 1"
  end

  def self.component_description
    "This is a storyless component"
  end

  def self.component_name
    "Component without stories"
  end

  def self.component_props
    [
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
