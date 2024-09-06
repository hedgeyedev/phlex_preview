# desc "Explaining what the task does"
# task :phlex_storybook do
#   # Task goes here
# end

module PhlexStorybook
  module Tasks
    class Install < Thor
      include Thor::Actions

      desc "install", "Install Phlex Storybook"
      def install
        say "Adding phlex_storybook to your application manifest..."
        append_to_file("app/assets/config/manifest.js", "//= link phlex_storybook_manifest.js\n")
      end
    end
  end
end
