Rails.application.routes.draw do

  root :to => 'bootstrap#index'
  post '/canvas/embedded/*url' => 'canvas_lti#embedded', :defaults => { :format => 'html' }
  get '/canvas/lti_leaderboard' => 'canvas_lti#lti_leaderboard', :defaults => { :format => 'xml' }

  namespace :api do
    namespace :v1 do
      resources :points, only: [:index, :show, :create, :update]
    end
  end
  resources :points, only: [:index, :show, :create, :update]

  get '/*url' => 'bootstrap#index', :defaults => { :format => 'html' }
end
