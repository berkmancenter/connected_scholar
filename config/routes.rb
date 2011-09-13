ConnectedScholar::Application.routes.draw do
  get "search/search"

  resources :documents do
    resources :comments
    resources :resources do
      get 'citation', :on => :member
      post 'activate', :on => :member
    end
    member do
      post "contributors", :action => "add_contributor", :as => :add_contributor
      delete "contributors/:contributor_id", :action => "remove_contributor", :as => :remove_contributor
    end
  end

  namespace :admin do
    resources :users, :only => [:index, :destroy] do
      post 'approve', :as => :approve
    end
  end

  root :to => "dashboard#index"

  devise_for :users, :path_names => { :sign_in => 'sign_in', :sign_out => 'sign_out', :sign_up => "sign_up" }

  match 'pad/'                      => 'pad#index'
  match 'view_pad/:document_id'     => 'pad#view_pad',  :document_id => /[^\/]+/, :as => :view_pad
  match 'pad/pad'                   => 'pad#pad'
  match 'p/:pad_id'                 => 'pad#pad',       :pad_id => /[^\/]+/
  match 'ro/:pad_id'                => 'pad#read_only', :pad_id => /[^\/]+/
  match 'p/:pad_id/export/:type'    => 'pad#export',    :pad_id => /[^\/]+/
  match 'p/:pad_id/timeslider'      => 'pad#timeslider',:pad_id => /[^\/]+/
  match 'ep/pad/connection-diagnostic-info' => 'pad#diagnostic'
end
