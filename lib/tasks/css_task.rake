require "tailwindcss-rails"

TAILWIND_BUILD_CMD = <<~SCRIPT.squish
  #{Tailwindcss::Engine.root.join("exe/tailwindcss")}
  -i #{PhlexStorybook::Engine.root.join("app/assets/stylesheets/phlex_storybook/application.tailwind.css")}
  -o #{PhlexStorybook::Engine.root.join("lib/phlex_storybook/assets/phlex_storybook_application.css")}
  -c #{PhlexStorybook::Engine.root.join("config/tailwind.config.js")}
SCRIPT

task :tailwind_engine_build do
  system TAILWIND_BUILD_CMD
end

task :tailwind_engine_watch do
  system TAILWIND_BUILD_CMD + " -w"
end

Rake::Task["app:assets:precompile"].enhance ["tailwind_engine_build"]
