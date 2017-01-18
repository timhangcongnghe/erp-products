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
      resources :manufacturings do
				collection do
					post 'list'
          delete 'delete_all'
          put 'draft'
          put 'draft_all'
          put 'manufacturing'
          put 'manufacturing_all'
          put 'finished'
          put 'finished_all'
				end
			end
      resources :units do
        collection do
          get 'dataselect'
        end
      end
      resources :products_units do
				collection do
          get 'form_line'
				end
			end
      resources :products_parts do
				collection do
					post 'list'
          get 'part_form'
				end
			end
      resources :price_lists do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
          put 'enable_all'
          put 'disable_all'
          put 'enable'
          put 'disable'
				end
			end
    end
	end
end