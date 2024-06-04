# frozen_string_literal: true

class LabelizedTimeInput < LabelizedMagnitudeInput
  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new(
      "Labelized Time Input",
      self,
      active: name == active_component_name,
      explanatory_component: LabelizedMagnitudeExplanation,
      kw_args: {label: "Time Input Label", name: "input_name", min: "09:00", max: "17:00"},
    )
  end

  def self.categories
    ["Input Components"]
  end

  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "time", vertical: vertical, **attrs)
  end
end
