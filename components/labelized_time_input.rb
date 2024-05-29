# frozen_string_literal: true

class LabelizedTimeInput < LabelizedMagnitudeInput
  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "time", vertical: vertical, **attrs)
  end
end
