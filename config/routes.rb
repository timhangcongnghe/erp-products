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
      resources :related_categories do
				collection do
          get 'related_category_line_form'
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
          post 'list'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
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
      resources :damage_records do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'damage_record_confirm'
          put 'archive'
          put 'unarchive'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
      resources :damage_record_details do
				collection do
          get 'damage_record_line_form'
				end
			end
      resources :stock_checks do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'stock_check_confirm'
          put 'archive'
          put 'unarchive'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
      resources :stock_check_details do
				collection do
          get 'stock_check_line_form'
				end
			end
    end
	end
end