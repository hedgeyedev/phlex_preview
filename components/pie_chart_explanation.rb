# frozen_string_literal: true

class PieChartExplanation < Phlex::HTML
  def view_template
    div { 'Toggle the "Horizontal?" checkbox to swap the label layout' }
    render LabelizedCheckbox.new(
      id: "horizontal-checkbox",
      label: "Horizontal?",
      name: "_horizontal",
      checked: true,
    )
    render LabelizedInput.new(
      id: "values-input",
      label: "Values",
      name: "values",
      placeholder: "yellowgreen 40%, gold 30%, #f06 remainder",
      type: "text",
    )
    plain <<~TEXT
      The values should be a comma-separated list of color and percentages.
      E.g. #036 20%, #063 30%, grey 15.2, black 17.8, #f06 remainder
    TEXT
    script do
      unsafe_raw <<~JS
        document.addEventListener('DOMContentLoaded', function() {
          const checkbox = document.getElementById('horizontal-checkbox'),
                valuesInput = document.getElementById('values-input');
          checkbox.addEventListener('change', function() {
            const container = document.querySelector('#component_view .piechart-container');
            container.classList.toggle('horizontal');
          });
          valuesInput.addEventListener('change', function() {
            const pieChart = document.querySelector('#component_view .piechart'),
                  values = valuesInput.value.split(',').map(v => v.trim()),
                  colorPercentages = values.map(v => v.split(' ')),
                  stops = [];
            let accumulator = 0;
            for (let i = 0; i < colorPercentages.length; i++) {
              const [color, percentage] = colorPercentages[i];
              if (percentage === 'remainder') {
                stops.push(`${color} 0`);
              } else {
                accumulator += parseFloat(percentage);
                stops.push(`${color} 0 ${accumulator}%`);
              }
            }
            pieChart.style.background = `conic-gradient(${stops.join(', ')})`;
          });
        });
      JS
    end
  end
end
