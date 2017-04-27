module Erp::Products
  class EventsProduct < ApplicationRecord
    belongs_to :product
    belongs_to :event
    
    def product_name
      product.nil? ? '' : product.name
    end
    
    def product_code
      product.nil? ? '' : product.code
    end
    
    def product_price
      product.nil? ? '' : product.price
    end
  end
end