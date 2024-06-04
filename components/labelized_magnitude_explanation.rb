class LabelizedMagnitudeExplanation < Phlex::HTML
  def view_template
    div { "Toggle the vertical checkbox to see a different view" }
    render LabelizedCheckbox.new(id: "vertical-checkbox", label: "Vertical?", name: "_vertical", checked: true)
    div(style: "display: grid; grid-template-columns: 1fr; gap: 5px") do
      div { render LabelizedInput.new(label: "Min", name: "min", type: "text", vertical: false) }
      div { render LabelizedInput.new(label: "Max", name: "max", type: "text", vertical: false) }
      div { render LabelizedInput.new(label: "Label", name: "labelizer", type: "text", vertical: false) }
    end
    script_support
  end

  def script_support
    script do
      unsafe_raw <<~JS
        document.addEventListener('DOMContentLoaded', function() {
          const checkbox  = document.getElementById('vertical-checkbox')
                min       = document.getElementById('min'),
                max       = document.getElementById('max'),
                labelizer = document.getElementById('labelizer'),
                field     = document.querySelector('#component_view .field'),
                input     = field.querySelector('input'),
                label     = field.querySelector('label');

          checkbox.addEventListener('change',  (_e) => { field.classList.toggle('vertical') });
          min.addEventListener('change',       (_e) => { input.min = min.value });
          max.addEventListener('change',       (_e) => { input.max = max.value });
          labelizer.addEventListener('change', (_e) => { label.innerText = labelizer.value });
        });
      JS
    end
  end
end
