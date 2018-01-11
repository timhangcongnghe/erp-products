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
    end
  end
end
