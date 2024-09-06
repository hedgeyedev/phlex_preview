require "tailwindcss-rails"
require_relative "../phlex_storybook/tasks/install"

TAILWIND_BUILD_CMD = <<~SCRIPT.squish
  #{Tailwindcss::Engine.root.join("exe/tailwindcss")}
  -i #{PhlexStorybook::Engine.root.join("app/assets/stylesheets/phlex_storybook/application.tailwind.css")}
  -o #{PhlexStorybook::Engine.root.join("lib/phlex_storybook/assets/phlex_storybook_application.css")}
  -c #{PhlexStorybook::Engine.root.join("config/tailwind.config.js")}
SCRIPT

namespace :phlex_storybook do
  desc "Install Phlex Storybook"
  task :install do
    PhlexStorybook::Tasks::Install.start(["install"])
  end
end

# the following are private to the engine
task :tailwind_engine_build do
  system TAILWIND_BUILD_CMD
end

task :tailwind_engine_watch do
  system TAILWIND_BUILD_CMD + " -w"
end
