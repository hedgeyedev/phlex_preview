# frozen_string_literal: true

class BarChart < Phlex::HTML
  attr_reader :bar_color, :bar_hover_color, :text_color, :bg_color

  def self.as_component_selector(active_component_name = nil)
    ComponentSelector.new(
      "Bar Chart",
      self,
      active: name == active_component_name,
      kw_args: {
        label: "HTML/CSS BarChart",
        values: {
          "IE 11"   => 11.33,
          "Chrome"  => 49.77,
          "Firefox" => 16.09,
          "Safari"  => 5.41,
          "Opera"   => 1.62,
          "Brave"   => 13.5,
          "Other"   => 2.28,
        },
        label_styles: "font-size: 0.7rem; font-weight: 900; text-transform: uppercase;",
      },
    )
  end

  def self.catgories
    ["Charts"]
  end

  def initialize(label:, values:, **attrs)
    @label           = label
    @values          = values
    @attrs           = attrs
    @id              = attrs.delete(:id) || label.downcase.underscore
    @bar_color       = @attrs.delete(:bar_color) || "#39a275"
    @bar_hover_color = @attrs.delete(:bar_hover_color) || "#82caaf"
    @text_color      = @attrs.delete(:text_color) || "#333333"
    @bg_color        = @attrs.delete(:bg_color) || "#ffffff"
    @label_styles    = @attrs.delete(:label_styles) || ""
  end

  def view_template
    div(class: "barchart", **@attrs) do
      dl do
        dt(style: @label_styles) { @label }
        @values.each.with_index do |(key, value), index|
          dd(class: "percentage percentage-#{index}") { span(class: "text") { format("%s: %0.2f%%", key, value) } }
        end
      end
    end
    app_script
    app_styles
  end

  private

  def app_script
    script do
      unsafe_raw <<~JS
        function hex2hslValues(hexValue) {
          // Convert hex to RGB first
          let r = 0, g = 0, b = 0;
          if (hexValue.length == 4) {
            r = "0x" + hexValue[1] + hexValue[1];
            g = "0x" + hexValue[2] + hexValue[2];
            b = "0x" + hexValue[3] + hexValue[3];
          } else if (hexValue.length == 7) {
            r = "0x" + hexValue[1] + hexValue[2];
            g = "0x" + hexValue[3] + hexValue[4];
            b = "0x" + hexValue[5] + hexValue[6];
          }
          // Then to HSL
          r /= 255;
          g /= 255;
          b /= 255;
          let cmin = Math.min(r,g,b),
              cmax = Math.max(r,g,b),
              delta = cmax - cmin,
              h = 0,
              s = 0,
              l = 0;

          if (delta == 0)
            h = 0;
          else if (cmax == r)
            h = ((g - b) / delta) % 6;
          else if (cmax == g)
            h = (b - r) / delta + 2;
          else
            h = (r - g) / delta + 4;

          h = Math.round(h * 60);

          if (h < 0)
            h += 360;

          l = (cmax + cmin) / 2;
          s = delta == 0 ? 0 : delta / (1 - Math.abs(2 * l - 1));
          s = +(s * 100).toFixed(1);
          l = +(l * 100).toFixed(1);

          return {hue: h, saturation: s, lightness: l};
        }
        function hslValuesToHslString(hue, saturation, lightness) {
          return `hsl(${hue}, ${saturation}%, ${lightness}%)`;
        }
        function hsl2hex(h,s,l) {
          s /= 100;
          l /= 100;

          let c = (1 - Math.abs(2 * l - 1)) * s,
              x = c * (1 - Math.abs((h / 60) % 2 - 1)),
              m = l - c/2,
              r = 0,
              g = 0,
              b = 0;

          if (0 <= h && h < 60) {
            r = c; g = x; b = 0;
          } else if (60 <= h && h < 120) {
            r = x; g = c; b = 0;
          } else if (120 <= h && h < 180) {
            r = 0; g = c; b = x;
          } else if (180 <= h && h < 240) {
            r = 0; g = x; b = c;
          } else if (240 <= h && h < 300) {
            r = x; g = 0; b = c;
          } else if (300 <= h && h < 360) {
            r = c; g = 0; b = x;
          }
          // Having obtained RGB, convert channels to hex
          r = Math.round((r + m) * 255).toString(16);
          g = Math.round((g + m) * 255).toString(16);
          b = Math.round((b + m) * 255).toString(16);

          // Prepend 0s, if necessary
          if (r.length == 1)
            r = "0" + r;
          if (g.length == 1)
            g = "0" + g;
          if (b.length == 1)
            b = "0" + b;

          return "#" + r + g + b;
        }
        function contrastedHslString(hue, saturation, lightness) {
          const newLightness = lightness > 50 ? lightness - 15 : lightness + 15;
          if (hue === 0 && saturation === 0 && lightness === 0) return hsl2hex(0, 0, 25);
          if (hue === 0 && saturation === 0 && lightness === 100) return hsl2hex(0, 0, 85);
          if (saturation < 50 && newLightness < 100) return hsl2hex(hue, saturation, newLightness);

          return hsl2hex(hue, saturation, lightness - 15);
        }
        function contrastColor(colorValue) {
          if (typeof colorValue === "object") return contrastedHslString({hue, saturation, lightness} = colorValue);

          if (colorValue.startsWith("#")) {
            const values     = hex2hslValues(colorValue),
                  hue        = values.hue,
                  saturation = values.saturation,
                  lightness  = values.lightness;
            return contrastedHslString(hue, saturation, lightness);
          } else {
            const values = colorValue.split(","),
                  hue        = parseFloat(values[0].replace("hsl(", ""), 10),
                  saturation = parseFloat(values[1], 10),
                  lightness  = parseFloat(values[2], 10);

            return contrastedHslString(hue, saturation, lightness);
          }
        }
      JS
    end
  end

  def app_styles
    style do
      unsafe_raw <<~CSS
        .barchart {
          height: 500px;
          font-family: "fira-sans-2", sans-serif;
          color: var(--barchart-text-color);
        }
        .barchart dl {
          display: flex;
          background-color: var(--barchart-bg-color);
          flex-direction: column;
          width: 100%;
          max-width: 700px;
          position: relative;
          padding: 20px;
        }
        .barchart dt {
          align-self: flex-start;
          width: 100%;
          font-weight: 700;
          display: block;
          text-align: center;
          font-size: 1.2em;
          font-weight: 700;
          margin-bottom: 20px;
          /*
            margin-left: 130px;
          */
        }
        .barchart .text {
          font-weight: 600;
          display: flex;
          align-items: center;
          height: 40px;
          width: 130px;
          background-color: var(--barchart-bg-color);
          position: absolute;
          left: 0;
          justify-content: flex-end;
        }
        .barchart .percentage {
          font-size: .8em;
          line-height: 1;
          text-transform: uppercase;
          height: 40px;
          margin-left: 130px;
          background: repeating-linear-gradient(
            to right,
            var(--barchart-grid-lines),
            var(--barchart-grid-lines) 1px,
            var(--barchart-bg-color) 1px,
            var(--barchart-bg-color) 5%
          );
          /*
            width: 100%;
          */
        }
        .barchart .percentage:after {
          content: "";
          display: block;
          background-color: var(--barchart-bar-color);
          width: 50px;
          margin-bottom: 10px;
          height: 90%;
          position: relative;
          top: 50%;
          transform: translateY(-50%);
          transition: background-color .3s ease;
          cursor: pointer;
        }
        .barchart .percentage:hover:after, .barchart .percentage:focus:after {
          background-color: var(--barchart-bar-hover-color);
        }
        #{
          @values.values.map.with_index do |value, index|
            ".barchart .percentage-#{index}:after { width: #{value}%; }"
          end.join("\n")
        }
        :root {
          --barchart-bg-color: #{bg_color};
          --barchart-bar-color: #{bar_color};
          --barchart-text-color: #{text_color};
          --barchart-bar-hover-color: #{bar_hover_color};
          --barchart-grid-lines: contrastColor("#{bg_color}");
        }
      CSS
    end
  end
end
