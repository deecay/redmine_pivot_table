# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/pivottables' => 'pivottables#index'

resources :projects do
  resources :pivottables, :only => [:index]
end
