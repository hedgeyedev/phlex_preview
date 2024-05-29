# frozen_string_literal: true

class LabelizedMagnitudeInput < LabelizedInput
  include ValidateableInput

  def initialize(label:, name:, type:, vertical: true, **attrs)
    @max = attrs.delete(:max)
    @min = attrs.delete(:min)
    super
  end

  protected

  def input_args
    super.merge(min: @min || "any", max: @max || "any")
  end
end
