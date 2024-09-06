require "thor"

module PhlexStorybook
  module Tasks
    class Install < Thor
      include Thor::Actions

      desc "install", "Install Phlex Storybook"
      def install
        say "Adding phlex_storybook to your application manifest..."
        append_to_file("app/assets/config/manifest.js", "//= link phlex_storybook_manifest.js\n")
        create_file("config/initializers/phlex_storybook.rb") do
          <<~RUBY
            # frozen_string_literal: true
            #
            # Make sure to add register_component blocks to your components
            #
            # Example:
            # register_component do
            #   component_category "Category 1"
            # end

            Dir[Rails.root.join("app/components/**/*.rb").to_s].each { |file| require file }
          RUBY
        end
      end
    end
  end
end
