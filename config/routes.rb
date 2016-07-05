Rails.application.routes.draw do

  #get 'vivayo/welcome'  => 'vivayo#welcome'

  devise_for :users,:controllers => { registrations: 'registrations' }
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".


  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'home/contact' => 'home#contact'

  get 'home/service' => 'home#service'

  get 'home/about' => 'home#about'
  
  post 'users/:id' => 'users#update'
  
  resources :users do
    get 'organisations'
    get 'joinus'
  end
 
  post '/tinymce_assets' => 'tinymce_assets#create'
  
  resources :posts  do
    get 'save_comment'
    get 'show_post_and_comment'
    get 'refresh_comments'
    post 'like_unlike_post_and_comment'
    get "serve", :on => :member
    get "list_grid_view"
    get "search_post"
    collection do
      get 'all_post'
      post 'mark_read_to_notification'
    end
  end
  get 'posts/:comment_id/edit_and_delete_comment' => 'posts#edit_and_delete_comment'
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
