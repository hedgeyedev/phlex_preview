# frozen_string_literal: true

class LabelizedNumberInput < LabelizedMagnitudeInput
  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "number", vertical: vertical, **attrs)
  end
end
