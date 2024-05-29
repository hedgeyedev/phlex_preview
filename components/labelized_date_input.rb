# frozen_string_literal: true

class LabelizedDateInput < LabelizedMagnitudeInput
  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "date", vertical: vertical, **attrs)
  end
end
