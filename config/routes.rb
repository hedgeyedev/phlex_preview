PhlexStorybook::Engine.routes.draw do
  root to: 'stories#index'

  resources :components, only: [:update]
  resources :experiments do
    member do
      get :preview
    end

    collection do
      # for monaco editor linked to experiments
      get 'codicon.ttf', to: redirect('/assets/phlex_storybook/codicon.ttf')
    end
  end

  resources :stories, only: [:index, :show, :update] do
    collection do
      get :all

      # for monaco editor linked to components
      get 'codicon.ttf', to: redirect('/assets/phlex_storybook/codicon.ttf')
    end
  end
end
