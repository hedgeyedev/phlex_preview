PhlexStorybook::Engine.routes.draw do
  root to: 'stories#index'

  resources :components, only: [:update]

  resources :stories, only: [:index, :show, :update] do
    collection do
      get :all

      get 'codicon.ttf', to: redirect(
        'https://cdn.jsdelivr.net/npm/monaco-editor@0.51.0/esm/vs/base/browser/ui/codicons/codicon/codicon.ttf')
    end
  end
end
