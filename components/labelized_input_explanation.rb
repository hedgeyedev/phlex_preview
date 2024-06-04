class LabelizedInputExplanation < Phlex::HTML
  def view_template
    div { "Toggle the vertical checkbox to see a different view" }
    render LabelizedCheckbox.new(id: "vertical-checkbox", label: "Vertical?", name: "_vertical", checked: true)
    div(style: "display: grid; grid-template-columns: 1fr; gap: 5px") do
      div { render LabelizedInput.new(label: "Label", name: "labelizer", type: "text", vertical: false) }
    end
    script_support
  end

  def script_support
    script do
      unsafe_raw <<~JS
        document.addEventListener('DOMContentLoaded', function() {
          const checkbox  = document.getElementById('vertical-checkbox')
                labelizer = document.getElementById('labelizer'),
                field     = document.querySelector('#component_view .field'),
                input     = field.querySelector('input'),
                label     = field.querySelector('label');

          checkbox.addEventListener('change',  (_e) => { field.classList.toggle('vertical') });
          labelizer.addEventListener('change', (_e) => { label.innerText = labelizer.value });
        });
      JS
    end
  end
end
