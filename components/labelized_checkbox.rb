# frozen_string_literal: true

class LabelizedCheckbox < Phlex::HTML
  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new(
      "Labelized Checkbox",
      self,
      active: name == active_component_name,
      kw_args: {label: "Checkbox Label", name: "checkbox_name", left: true},
    )
  end

  def self.categories
    ["Input Components"]
  end

  def initialize(label:, name:, left: true, **attrs)
    @label = label
    @name  = name
    @left  = left
    @id    = attrs.delete(:id) || name
    @attrs = attrs
  end

  def left?
    @left
  end

  def view_template
    app_styles
    div(**classes("checkbox", left?: "left")) do
      label(for: @id) { @label }
      input(type: 'checkbox', name: @name, id: @id, **@attrs)
    end
  end

  def app_styles
    style do
      unsafe_raw <<~CSS
        .checkbox {
          display: flex;
          gap: 3px;
          flex-direction: row;
        }
        .checkbox > label {
          order: 2;
          font-weight: 700;
          text-transform: uppercase;
          display: block;
          margin: auto 0;
        }
        .checkbox.left > label {
          order: 1;
        }
        .checkbox > input[type="checkbox"] {
          order: 1;
          padding: 5px;
          border-radius: 4px;
          border: 1px solid #ddd;
          display: block;
        }
      CSS
    end
  end
end
