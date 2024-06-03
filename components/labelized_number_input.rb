# frozen_string_literal: true

class LabelizedNumberInput < LabelizedMagnitudeInput
  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new(
      "Labelized Number Input",
      self,
      active: name == active_component_name,
      explanatory_component: LabelizedMagnitudeExplanation,
      kw_args: {label: "Number Input Label", name: "input_name"},
    )
  end

  def self.categories
    ["Input Components"]
  end

  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "number", vertical: vertical, **attrs)
  end
end
