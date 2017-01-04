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
          put 'archive'
          put 'unarchive'
        end
      end
      resources :products do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
          get 'form_property'
        end
      end
      resources :properties do
        collection do
          get 'dataselect'
        end
      end
      resources :properties_values do
        collection do
          get 'dataselect'
        end
      end
    end
	end
end