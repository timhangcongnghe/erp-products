Erp::Products::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/products" do
			resources :inventory_products do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
					put 'move_up'
					put 'move_down'
				end
			end
			resources :inventory_categories do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
					put 'move_up'
					put 'move_down'
				end
			end
      resources :categories do
        collection do
          post 'list'
          get 'dataselect'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
          put 'move_up'
          put 'move_down'
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
          put 'check_is_bestseller'
          put 'uncheck_is_bestseller'
          put 'check_is_bestseller_all'
          put 'uncheck_is_bestseller_all'
          put 'check_is_call'
          put 'uncheck_is_call'
          put 'check_is_call_all'
          put 'uncheck_is_call_all'
          put 'check_is_sold_out'
          put 'uncheck_is_sold_out'
          put 'check_is_sold_out_all'
          put 'uncheck_is_sold_out_all'
          put 'check_is_stock_inventory'
          put 'uncheck_is_stock_inventory'
          put 'check_is_stock_inventory_all'
          put 'uncheck_is_stock_inventory_all'
          put 'check_is_business_choices'
          put 'uncheck_is_business_choices'
          put 'check_is_business_choices_all'
          put 'uncheck_is_business_choices_all'
          put 'check_is_top_business_choices'
          put 'uncheck_is_top_business_choices'
          put 'check_is_top_business_choices_all'
          put 'uncheck_is_top_business_choices_all'
          get 'form_property'
          get 'property_form'

					#@todo HK-ERP connector
          get 'hkerp_products'
          post 'hkerp_products_list'
          get 'hkerp_categories_dataselect'
          put 'hkerp_update_price'
          get 'hkerp_manufacturers_dataselect'

          get 'dataselect_code'

          post 'import_export_table' # @todo if qdeliveries available
          get 'product_details'
          get 'xlsx'
        end
      end
      resources :states do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'status_draft'
					put 'status_active'
					put 'status_deleted'
					put 'status_draft_all'
					put 'status_active_all'
					put 'status_deleted_all'
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
				end
			end
      resources :state_checks do
				collection do
					post 'list'
					get 'dataselect'
					delete 'delete_all'
					put 'status_draft'
					put 'status_active'
					put 'status_deleted'
					put 'status_draft_all'
					put 'status_active_all'
					put 'status_deleted_all'
					put 'archive'
					put 'unarchive'
					put 'archive_all'
					put 'unarchive_all'
					get 'state_check_details'
				end
			end
      resources :state_check_details do
				collection do
          get 'state_check_detail_line_form'
				end
			end
      resources :properties do
        collection do
          get 'dataselect'
          post 'list'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'

          put 'move_up'
          put 'move_down'
        end
      end
      resources :properties_values do
        collection do
          get 'dataselect'
          post 'list'
          get 'export_products'
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
          get 'damage_record_details'
          get 'dataselect'
          delete 'delete_all'
          put 'set_confirm'
          put 'set_delete'
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
          get 'stock_check_details'
          get 'dataselect'
          delete 'delete_all'
          put 'set_draft'
          put 'set_done'
          put 'set_deleted'
          put 'archive'
          put 'unarchive'
          put 'archive_all'
          put 'unarchive_all'
          get 'ajax_stock_col'

          get 'form_check_details'
          post 'table_stock_check_details'
        end
      end
      resources :stock_check_details do
				collection do
          get 'stock_check_line_form'
				end
			end
      resources :brands do
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
      resources :brand_groups do
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
      resources :brand_group_details do
				collection do
          get 'brand_group_detail_line_form'
				end
			end
      resources :property_groups do
        collection do
          get 'dataselect'
          post 'list'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'

          put 'move_up'
          put 'move_down'
          get 'dataselect'
        end
      end
      resources :accessories do
        collection do
          get 'dataselect'
          post 'list'
          put 'archive'
          put 'unarchive'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
        end
      end
      resources :accessory_details do
				collection do
          get 'accessory_detail_line_form'
				end
			end
      resources :comments do
        collection do
          post 'list'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
          get 'children_comments'
        end
      end
      resources :ratings do
        collection do
          post 'list'
          delete 'delete_all'
          put 'archive_all'
          put 'unarchive_all'
          put 'archive'
          put 'unarchive'
        end
      end
      resources :events do
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
      resources :events_products do
				collection do
          get 'event_product_line_form'
				end
			end
      resources :products_gifts do
				collection do
          get 'gift_form'
				end
			end
    end
	end
end
