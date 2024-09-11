# frozen_string_literal: true
#
# Make sure to add the DSL and invoke ".storybook" in your components
#
# Example:
#   class DummyComponent < Phlex::HTML
#     include PhlexStorybook::DSL
#     storybook do
#       category "Category 1"
#     end
#   end

Dir[Rails.root.join("app/components/**/*.rb").to_s].each { |file| require file }
