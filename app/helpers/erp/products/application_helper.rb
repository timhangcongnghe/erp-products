module Erp
  module Products
    module ApplicationHelper

      # Product dropdown actions
      def product_dropdown_actions(product)
        actions = []
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('edit'),
          url: erp_products.edit_backend_product_path(product)
        } if can? :update, product
        if Erp::Core.available?("ortho_k")
          actions << {
            text: '<i class="fa fa-compress"></i> '+t('.combine'),
            url: erp_products.combine_backend_products_path(id: product)
          } if can? :combine, product
          actions << {
            text: '<i class="fa fa-expand"></i> '+t('.split'),
            url: erp_products.split_backend_products_path(id: product)
          } if can? :split, product
        end
        actions << { divider: true }  if (can? :update, product) or ((can? :combine, product) and (can? :split, product))
        actions << {
          text: '<i class="fa fa-ban"></i> '+t('archive'),
          url: erp_products.archive_backend_products_path(id: product),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.archive_confirm')
        } if can? :archive, product
        actions << {
          text: '<i class="fa fa-check"></i> '+t('unarchive'),
          url: erp_products.unarchive_backend_products_path(id: product),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.unarchive_confirm')
        } if can? :unarchive, product

        erp_datalist_row_actions(
          actions
        )
      end

      # product link helper
      def backend_product_link(product, text=nil)
        text = text.nil? ? product.name : text
        raw "<a href='#{erp_products.backend_product_path(product)}' class='modal-link'>#{text}</a>"
      end

      # Damage records
      def damage_record_dropdown_actions(damage_record)
        actions = []
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('edit'),
          href: erp_products.edit_backend_damage_record_path(damage_record)
        } if can? :update, damage_record
        actions << {
          text: '<i class="fa fa-clipboard"></i> '+t('.set_draft'),
          url: erp_products.set_draft_backend_damage_records_path(id: damage_record),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_draft, damage_record
        actions << {
          text: '<i class="fa fa-hand-pointer-o"></i> '+t('.set_pending'),
          url: erp_products.set_pending_backend_damage_records_path(id: damage_record),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_pending, damage_record
        actions << {
          text: '<i class="fa fa-check"></i> '+t('.approve'),
          url: erp_products.set_confirm_backend_damage_records_path(id: damage_record),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_done, damage_record

        if can? :set_deleted, damage_record
          if (can? :update, damage_record) or (can? :set_draft, damage_record) or (can? :set_pending, damage_record) or (can? :set_done, damage_record)
            actions << { divider: true }
          end
        end

        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.delete'),
          url: erp_products.set_delete_backend_damage_records_path(id: damage_record),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('delete_confirm')
        } if can? :set_deleted, damage_record

        erp_datalist_row_actions(
          actions
        )
      end

      # Stock check
      def stock_check_dropdown_actions(stock_check)
        actions = []
        actions << {
          text: '<i class="fa fa-print"></i> '+t('.view_print'),
          url: erp_products.backend_stock_check_path(stock_check),
          class: 'modal-link'
        } if can? :print, stock_check
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('edit'),
          href: erp_products.edit_backend_stock_check_path(stock_check)
        } if can? :update, stock_check
        actions << {
          text: '<i class="fa fa-clipboard"></i> '+t('.set_draft'),
          url: erp_products.set_draft_backend_stock_checks_path(id: stock_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_draft, stock_check
        actions << {
          text: '<i class="fa fa-hand-pointer-o"></i> '+t('.set_pending'),
          url: erp_products.set_pending_backend_stock_checks_path(id: stock_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_pending, stock_check
        actions << {
          text: '<i class="fa fa-check"></i> '+t('.approve'),
          url: erp_products.set_done_backend_stock_checks_path(id: stock_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_done, stock_check

        if can? :set_deleted, stock_check
          if (can? :print, stock_check) or (can? :update, stock_check) or (can? :set_draft, stock_check) or (can? :set_pending, stock_check) or (can? :set_done, stock_check)
            actions << { divider: true }
          end
        end

        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.delete'),
          url: erp_products.set_deleted_backend_stock_checks_path(id: stock_check),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('delete_confirm')
        } if can? :set_deleted, stock_check

        erp_datalist_row_actions(
          actions
        )
      end

      # State check
      def state_check_dropdown_actions(state_check)
        actions = []
        actions << {
          text: '<i class="fa fa-print"></i> '+t('.view_print'),
          url: erp_products.backend_state_check_path(state_check),
          class: 'modal-link'
        } if can? :print, state_check
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('edit'),
          href: erp_products.edit_backend_state_check_path(state_check)
        } if can? :update, state_check
        actions << {
          text: '<i class="fa fa-clipboard"></i> '+t('.set_draft'),
          url: erp_products.set_draft_backend_state_checks_path(id: state_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_draft, state_check
        actions << {
          text: '<i class="fa fa-hand-pointer-o"></i> '+t('.set_pending'),
          url: erp_products.set_pending_backend_state_checks_path(id: state_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_pending, state_check
        actions << {
          text: '<i class="fa fa-check"></i> '+t('.approve'),
          url: erp_products.set_active_backend_state_checks_path(id: state_check),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_active, state_check

        if can? :set_deleted, state_check
          if (can? :print, state_check) or (can? :update, state_check) or (can? :set_draft, state_check) or (can? :set_pending, state_check) or (can? :set_active, state_check)
            actions << { divider: true }
          end
        end

        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.delete'),
          url: erp_products.set_deleted_backend_state_checks_path(id: state_check),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('delete_confirm')
        } if can? :set_deleted, state_check

        erp_datalist_row_actions(
          actions
        )
      end

      # Product state dropdown actions
      def state_dropdown_actions(state)
        actions = []
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('.edit'),
          href: erp_products.edit_backend_state_path(state)
        } if can? :update, state
        actions << {
          text: '<i class="fa fa-clipboard"></i> '+t('.set_draft'),
          url: erp_products.set_draft_backend_states_path(id: state),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_draft, state
        actions << {
          text: '<i class="fa fa-check"></i> '+t('.set_active'),
          url: erp_products.set_active_backend_states_path(id: state),
          data_method: 'PUT',
          class: 'ajax-link'
        } if can? :set_active, state

        if can? :set_deleted, state
          if (can? :update, state) or (can? :set_draft, state) or (can? :set_active, state)
            actions << { divider: true }
          end
        end
        actions << {
          text: '<i class="fa fa-trash"></i> '+t('.set_deleted'),
          url: erp_products.set_deleted_backend_states_path(id: state),
          data_method: 'PUT',
          class: 'ajax-link',
          data_confirm: t('.set_deleted_confirm')
        } if can? :set_deleted, state

        erp_datalist_row_actions(
          actions
        )
      end

      # Product category dropdown actions
      def category_dropdown_actions(category)
        actions = []
        actions << {
          text: '<i class="fa fa-edit"></i> '+t('edit'),
          href: erp_products.edit_backend_category_path(category)
        } if can? :update, category
        actions << {
          text: '<i class="fa fa-eye-slash"></i> '+t('archive'),
          url: erp_products.archive_backend_categories_path(id: category),
          data_method: 'PUT',
          #hide: category.archived,
          class: 'ajax-link',
          data_confirm: t('.archive_confirm')
        } if can? :archive, category
        actions << {
          text: '<i class="fa fa-eye"></i> '+t('unarchive'),
          url: erp_products.unarchive_backend_categories_path(id: category),
          data_method: 'PUT',
          #hide: !category.archived,
          class: 'ajax-link',
          data_confirm: t('.unarchive_confirm')
        } if can? :unarchive, category

        erp_datalist_row_actions(actions)
      end
    end
  end
end