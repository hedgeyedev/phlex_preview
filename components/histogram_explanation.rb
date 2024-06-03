# frozen_string_literal: true

class HistogramExplanation < Phlex::HTML
  def view_template
    plain <<~TEXT
      The histogram component is a simple component that displays a series of values as a series of bars.
      The height of each bar is determined by the value it represents. The color of the bars is determined
      by the CSS variable `--histogram-bar-color`.

      NOTE: THIS IS A WORK IN PROGRESS. THE STYLES ARE NOT YET CUSTOMIZABLE AND THE COMPONENT IS NOT YET
      COMPLETE.
    TEXT
    render LabelizedInput.new(
      id: "bg-input",
      label: "Background Color",
      type: "color",
      value: "#ffffff",
    )
    render LabelizedInput.new(
      id: "color-input",
      label: "Text Color",
      type: "color",
      value: "#333333",
    )
    render LabelizedInput.new(
      id: "grid-line-input",
      label: "Grid Line Color",
      type: "color",
      value: "#333333",
    )
    render LabelizedInput.new(
      id: "bar-color-input",
      label: "Bar Color",
      type: "color",
      value: "#39a275",
    )
    render LabelizedInput.new(
      id: "hover-color-input",
      label: "Hover Color",
      type: "color",
      value: "#82caaf",
    )
    script do
      unsafe_raw <<~JS
        document.addEventListener('DOMContentLoaded', function() {
          const bgInput         = document.getElementById('bg-input'),
                barColorInput   = document.getElementById('bar-color-input'),
                colorInput      = document.getElementById('color-input'),
                gridLineInput   = document.getElementById('grid-line-input'),
                hoverColorInput = document.getElementById('hover-color-input'),
                docStyle        = document.documentElement.style;
          bgInput.addEventListener('change', (e) => {
            docStyle.setProperty('--barchart-bg-color', e.target.value);

            gridLineInput.value = contrastColor(e.target.value);
            gridLineInput.dispatchEvent(new Event('change'));

            colorInput.value = contrastColor(e.target.value);
            colorInput.dispatchEvent(new Event('change'));
          });
          barColorInput.addEventListener('change', (e) => {
            docStyle.setProperty('--barchart-bar-color', e.target.value)
          });
          colorInput.addEventListener('change', (e) => {
            docStyle.setProperty('--barchart-text-color', e.target.value)
            gridLineInput.value = e.target.value;
            gridLineInput.dispatchEvent(new Event('change'));
          });
          gridLineInput.addEventListener('change', (e) => {
            docStyle.setProperty('--barchart-grid-lines', e.target.value)
          });
          hoverColorInput.addEventListener('change', (e) => {
            docStyle.setProperty('--barchart-bar-hover-color', e.target.value)
          });
        });
      JS
    end
  end
end
