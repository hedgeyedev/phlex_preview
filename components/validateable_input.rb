# frozen_string_literal: true

module ValidateableInput
  def make_input
    div do
      super
      span(class: "validity")
    end
  end

  def app_styles
    super
    style do
      unsafe_raw <<~CSS
        .field input + span {
          padding-right: 30px;
        }

        .field input:invalid + span::after {
          position: absolute;
          content: "✖";
          padding-left: 5px;
          margin: auto 0;
        }

        .field input:valid + span::after {
          position: absolute;
          content: "✓";
          padding-left: 5px;
          margin: auto 0;
        }

        .field input {
          padding: 10px;
          display: inline-block;
        }
      CSS
    end
  end
end
