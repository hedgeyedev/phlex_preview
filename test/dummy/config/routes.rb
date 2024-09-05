Rails.application.routes.draw do
  mount PhlexStorybook::Engine => "/phlex_storybook"

  root to: "phlex_storybook/stories#index"
end
