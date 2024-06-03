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
  end
end
