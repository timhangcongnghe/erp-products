Erp::Products::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/products" do
      resources :categories do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
      resources :products do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
    end
	end
end