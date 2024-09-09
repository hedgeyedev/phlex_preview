# frozen_string_literal: true

class StorylessComponent < Phlex::HTML
  include PhlexStorybook::DSL

  storybook do
    category "Category 1"
    description "This is a storyless component"
    name "Component without stories"
    prop_string :header, default: "Default Header", required: true
    prop_text :text, label: "The list"
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
