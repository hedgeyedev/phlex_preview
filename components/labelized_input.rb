# frozen_string_literal: true

class LabelizedInput < Phlex::HTML
  def initialize(label:, name:, type:, vertical: true, **attrs)
    @label    = label
    @name     = name
    @id       = attrs.delete(:id) || name
    @type     = type
    @vertical = vertical
    @attrs    = attrs
  end

  def vertical?
    @vertical
  end

  def view_template
    app_styles
    div(**classes("field", vertical?: "vertical")) do
      make_label
      make_input
    end
  end

  protected

  def app_styles
    style do
      unsafe_raw <<~CSS
        .field {
          display: grid;
          grid-template-columns: minmax(10%, 1fr) 4fr;
          grid-gap: 3px;
        }
        .vertical {
          grid-template-columns: 1fr;
        }
        .field label {
          font-weight: 700;
          text-transform: uppercase;
          display: block;
          margin: auto 0;
        }
        .field input {
          min-width: fit-content;
          padding: 10px;
          border-radius: 4px;
          border: 1px solid #ddd;
          background-color: #f9f9f9;
          color: #333;
          display: block;
        }
      CSS
    end
  end

  def input_args
    { type: @type, name: @name, id: @id, **@attrs }
  end

  def make_label
    label(for: @name) { @label }
  end

  def make_input
    input(**input_args)
  end
end