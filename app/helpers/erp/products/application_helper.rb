module Erp
  module Products
    module ApplicationHelper
      # product link helper
      def backend_product_link(product, text=nil)
        text = text.nil? ? product.name : text
        raw "<a href='#{erp_products.backend_product_path(product)}' class='modal-link'>#{text}</a>"
      end
    end
  end
end
