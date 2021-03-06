ConnectedScholar::Application.routes.draw do
  get "search/keyword"
  get "search/advanced"
  get "search/google"

  resources :documents do
    resources :comments, :only => [:create, :destroy] do
      post 'read', :on => :member
    end
    resources :resources, :only => [:show, :create, :destroy] do
      resources :quotations, :only => [:show, :create, :destroy]
      resources :citations, :only => [:create, :destroy]
      get 'citation', :on => :member
      post 'activate', :on => :member
      member do
        post "default_citation/:citation_id", :action => "promote_citation", :as => :promote_citation
      end
    end
    member do
      get "active_citations", :action => "active_citations", :as => :active_citations
      post "contributors", :action => "add_contributor", :as => :add_contributor
      post "refresh_resources", :action => "refresh_resources", :as => :refresh_resources
      delete "contributors/:contributor_id", :action => "remove_contributor", :as => :remove_contributor
    end
  end

  namespace :admin do
    resources :users, :only => [:index, :destroy] do
      post 'approve', :as => :approve
      post 'promote', :as => :promote
      post 'demote', :as => :demote
    end
  end

  root :to => "dashboard#index"

  devise_for :users,
             :controllers => { :registrations => "registrations" },
             :path_names => { :sign_in => 'sign_in', :sign_out => 'sign_out', :sign_up => "sign_up" } do
    get "users/preferences" => "users#preferences", :as => :user_preferences
    post "users/preferences" => "users#save_preferences", :as => :user_preferences
  end

  match 'pad/'                      => 'pad#index'
  match 'view_pad/:document_id'     => 'pad#view_pad',  :document_id => /[^\/]+/, :as => :view_pad
  match 'pad/pad'                   => 'pad#pad'
  match 'p/:pad_id'                 => 'pad#pad',       :pad_id => /[^\/]+/
  match 'ro/:pad_id'                => 'pad#read_only', :pad_id => /[^\/]+/
  match 'p/:pad_id/export/:type'    => 'pad#export',    :pad_id => /[^\/]+/
  match 'p/:pad_id/timeslider'      => 'pad#timeslider',:pad_id => /[^\/]+/
  match 'ep/pad/connection-diagnostic-info' => 'pad#diagnostic'

  get "help/getting_started"
  get "help/sharing_documents"
  get "help/finding_resources"
  get "help/citing_resources"
end
