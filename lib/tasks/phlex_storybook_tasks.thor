# desc "Explaining what the task does"
# task :phlex_storybook do
#   # Task goes here
# end

class PhlexStorybook < Thor
  include Thor::Actions

  desc "install", "Install Phlex Storybook"
  def install
    say "Hi! I'm going to install Phlex Storybook for you."
    exec "bin/importmap pin phlex_ui"
    append_to_file("app/javascript/application.js", "import 'phlex_ui';\n")
  end
end
