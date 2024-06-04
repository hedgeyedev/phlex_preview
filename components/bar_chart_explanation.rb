# frozen_string_literal: true

class BarChartExplanation < Phlex::HTML
  def view_template
    div do
      plain <<~TEXT
        The bar chart component is a simple component that displays a series of values as a series of bars.
        The width of each bar is determined by the value it represents. The following CSS variables can be
        set:
      TEXT
      ul do
        li do
          plain "background color: "
          code { "--barchart-bg-color" }
        end
        li do
          plain "text color: "
          code { "--barchart-text-color" }
        end
        li do
          plain "color of the grid lines: "
          code { "--barchart-grid-lines" }
        end
        li do
          plain "color of the bars: "
          code { "--barchart-bar-color" }
        end
        li do
          plain "hover color of the bars: "
          code { "--barchart-hover-color" }
        end
      end
    end
    plain "The initial grid line color is set to a contrasted version of the background color."
    render LabelizedInput.new(
      id: "bg-input",
      label: "Background Color",
      type: "color",
      value: "#ffffff",
      vertical: false,
    )
    render LabelizedInput.new(
      id: "color-input",
      label: "Text Color",
      type: "color",
      value: "#333333",
      vertical: false,
    )
    render LabelizedInput.new(
      id: "grid-line-input",
      label: "Grid Line Color",
      type: "color",
      value: "#333333",
      vertical: false,
    )
    render LabelizedInput.new(
      id: "bar-color-input",
      label: "Bar Color",
      type: "color",
      value: "#39a275",
      vertical: false,
    )
    render LabelizedInput.new(
      id: "hover-color-input",
      label: "Hover Color",
      type: "color",
      value: "#82caaf",
      vertical: false,
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
