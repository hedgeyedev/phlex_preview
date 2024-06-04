# frozen_string_literal: true

class LabelizedCheckboxExplanation < Phlex::HTML
  def view_template
    div { 'Toggle the "Left?" checkbox to swap the label ordering' }
    render LabelizedCheckbox.new(
      id: "left-checkbox",
      label: "Left?",
      name: "_left",
      checked: true,
    )
    script do
      unsafe_raw <<~JS
        document.addEventListener('DOMContentLoaded', function() {
          const checkbox = document.getElementById('left-checkbox');
          checkbox.addEventListener('change', function() {
            const field = document.querySelector('#component_view .checkbox');
            field.classList.toggle('left');
          });
        });
      JS
    end
  end
end
