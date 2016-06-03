# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/pivottables' => 'pivottables#index'
get '/projects/:project_id/pivottables/save' => 'pivottables#save'
post '/projects/:project_id/pivottables/save' => 'pivottables#save'
get '/projects/:project_id/pivottables/new' => 'pivottables#new'

resources :projects do
  resources :pivottables, :only => [:index]
end
