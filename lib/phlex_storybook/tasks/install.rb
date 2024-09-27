require "thor"

module PhlexStorybook
  module Tasks
    class Install < Thor
      include Thor::Actions

      desc "install", "Install Phlex Storybook"
      def install
        say "Adding phlex_storybook to your application manifest..."
        append_to_file("app/assets/config/manifest.js", "//= link phlex_storybook_manifest.js\n")

        create_file("tmp/experiments/sample_view.rb") do
          File.read(PhlexStorybook::Engine.root.join("lib/phlex_storybook/tasks/sample_view.rb"))
        end

        create_file("tmp/experiments/sample_component.rb") do
          File.read(PhlexStorybook::Engine.root.join("lib/phlex_storybook/tasks/sample_component.rb"))
        end

        create_file("config/initializers/phlex_storybook.rb") do
          <<~RUBY
            # frozen_string_literal: true

            # Make sure to add the DSL and invoke ".storybook" in your components
            #
            # Example:
            #   class DummyComponent < Phlex::HTML
            #     include PhlexStorybook::DSL
            #     storybook do
            #       category "Category 1"
            #     end
            #   end
            #
            # If you aren't using importmaps then you may have add this to your config/development.rb file:
            # 
            #   # See: https://stackoverflow.com/questions/77053696/importmap-rails-sprockets-not-finding-stimulus-loading-js-in-fresh-stimulus-ra 
            #   config.assets.digest = true
            # 

            PhlexStorybook.configuration.add_component_path("app/components")
          RUBY
        end
      end
    end
  end
end
