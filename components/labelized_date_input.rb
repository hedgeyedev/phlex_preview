# frozen_string_literal: true

class LabelizedDateInput < LabelizedMagnitudeInput
  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new(
      "Labelized Date Input",
      self,
      active: name == active_component_name,
      explanatory_component: LabelizedMagnitudeExplanation,
      kw_args: {label: "Date Input Label", name: "input_name"},
    )
  end

  def self.categories
    ["Input Components"]
  end

  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "date", vertical: vertical, **attrs)
  end
end
