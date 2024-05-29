# frozen_string_literal: true

class LabelizedDateTimeInput < LabelizedMagnitudeInput
  def initialize(label:, name:, vertical: true, **attrs)
    super(label: label, name: name, type: "datetime-local", vertical: vertical, **attrs)
  end
end
