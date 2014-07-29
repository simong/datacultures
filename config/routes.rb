Rails.application.routes.draw do

  root :to => 'bootstrap#index'
  post '/canvas/embedded/*url' => 'canvas_lti#embedded', :defaults => { :format => 'html' }
  get '/canvas/lti_engagement_index' => 'canvas_lti#lti_engagement_index', :defaults => { :format => 'xml' }
  get '/users/:course_id' => 'canvas_lti#students_list', :defaults => { :format => 'json'}
  get '/canvas/lti_points_configuration' => 'canvas_lti#lti_points_configuration', :defaults => { :format => 'xml'}
  post '/points_configuration/update' => 'points_configuration#update_all'

  namespace :api do
    namespace :v1 do
      resources :activities, only: [:index, :show, :create, :update]
    end
  end

  get '/*url' => 'bootstrap#index', :defaults => { :format => 'html' }
end
