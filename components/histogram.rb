# frozen_string_literal: true

class Histogram < Phlex::HTML
  def self.as_component_selector(active_component_name = nil)
    values  = 15.times.map { rand * 100 }
    average = -> { strong { format("Average Fluberhaits: %0.2f%%", values.sum / values.size) } }
    ComponentSelector.new(
      name,
      self,
      active: name == active_component_name,
      kw_args: {label: "Simple HTML/CSS Histogram", values: values, in_chart_highlight: average},
    )
  end

  def self.catgories
    ["Charts"]
  end

  def initialize(label:, values:, in_chart_highlight: nil, **attrs)
    @label              = label
    @values             = values.map { |v| v.to_f }
    @in_chart_highlight = in_chart_highlight
    @id                 = attrs.delete(:id) || label.downcase.underscore
    @attrs              = attrs
    @min                = @attrs.delete(:min) || @values.min
    @max                = @attrs.delete(:max) || @values.max
  end

  def view_template
    app_styles
    chart_styles  = @attrs.delete(:chart_styles)
    chart_classes = @attrs[:chart_classes]&.map(&:to_s)&.join(" ") || ""
    label_styles  = @attrs.delete(:label_styles)
    label_classes = @attrs[:label_classes]&.map(&:to_s)&.join(" ") || ""
    div(**classes("histogram #{chart_classes}")) do
      @values.each do |value|
        div(class: "histogram-bar", style: "height: #{height_of(value)}%") { format("%0.2f", value) }
      end
      label(**classes(label_classes)) { @label }
    end
  end

  private

  def app_styles
    style do
      unsafe_raw <<~CSS
        .histogram {
          display: flex;
          gap: 3px;
          flex-direction: row;
          height: 100px;
          width: 100%;
        }
        .histogram > label {
          order: 2;
          font-weight: 700;
          text-transform: uppercase;
          display: block;
          margin: auto 0;
        }
        .histogram-bar {
          background-color: #007bff;
          width: 2rem;
          color: white;
          text-align: center;
          border-radius: 4px;
          font-size: 0.5rem;
        }
        .histogram.left > label {
          order: 1;
        }
      CSS
    end
  end

  def height_of(value)
    ((value - @min) / (@max - @min) * 100).round
  end
end
