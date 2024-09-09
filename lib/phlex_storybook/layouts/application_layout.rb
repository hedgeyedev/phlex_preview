# frozen_string_literal: true

module PhlexStorybook
  module Layouts
    class ApplicationLayout < ApplicationView
      include Phlex::Rails::Layout
      include Phlex::Rails::Helpers::CSRFMetaTags
      include Phlex::Rails::Helpers::CSPMetaTag
      include Phlex::Rails::Helpers::TurboRefreshesWith

      def view_template(&)
        doctype

        html lang: "en" do
          head do
            meta charset: "UTF-8"
            meta name: "viewport", content: "width=device-width, initial-scale=1.0"
            title { "Phlex Component Preview" }
            csrf_meta_tags
            csp_meta_tag
            javascript_importmap_tags "phlex_storybook"
            stylesheet_link_tag "phlex_storybook_application", media: "all"
            turbo_refreshes_with method: :morph, scroll: :preserve
          end
          span(class: "fixed bottom-0 right-0 p-2 text-xs text-indigo-200") do
            "v#{PhlexStorybook::VERSION}"
          end
          body class: "bg-gray-100 text-gray-900 dark:bg-gray-900 dark:text-gray-100" do
            yield
          end
        end
      end
    end

    def identifier
      "phlex_storybook"
    end
  end
end
