PhlexStorybook::Engine.routes.draw do
  root to: 'stories#index'

  resources :stories, only: [:index, :show, :update] do
    collection do
      get :all
    end
  end
end
