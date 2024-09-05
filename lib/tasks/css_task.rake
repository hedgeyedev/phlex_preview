task :tailwind_engine_watch do
  require "tailwindcss-rails"
  # NOTE: tailwindcss-rails is an engine
  system "#{Tailwindcss::Engine.root.join("exe/tailwindcss")} \
         -i #{PhlexStorybook::Engine.root.join("app/assets/stylesheets/phlex_storybook/application.tailwind.css")} \
         -o #{PhlexStorybook::Engine.root.join("app/assets/builds/phlex_storybook_application.css")} \
         -c #{PhlexStorybook::Engine.root.join("config/tailwind.config.js")} \
         -w"
end
