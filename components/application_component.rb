# frozen_string_literal: true

class ApplicationComponent < Phlex::HTML
  def common_styles
    style do
      unsafe_raw <<-CSS
        body, html {
          font-family: 'Arial', sans-serif;
          color: #333;
          line-height: 1.6;
        }
        .rendered-results-preview, .raw-html {
          margin: 20px;
          padding: 10px;
          border: 1px solid #ccc;
          border-radius: 5px;
          background-color: #fff;
          overflow-x: auto;
        }
        .highlight {
          background-color: #f4f4f4;
          border: 1px dashed #ddd;
          font-family: 'Courier New', monospace;
          white-space: pre-wrap;
        }
      CSS
    end
  end
end
