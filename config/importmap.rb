pin "phlex_storybook", to: "phlex_storybook/application.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin 'monaco-editor', to: 'https://cdn.jsdelivr.net/npm/monaco-editor@0.51.0/+esm'

pin_all_from PhlexStorybook::Engine.root.join("app/javascript/phlex_storybook/controllers"), under: "controllers", to: "phlex_storybook/controllers"
