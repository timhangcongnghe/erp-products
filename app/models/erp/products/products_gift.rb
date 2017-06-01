module Erp::Products
  class ProductsGift < ApplicationRecord
    belongs_to :product
    belongs_to :gift, class_name: 'Erp::Products::Product'
    
    def gift_code
      gift.nil? ? '' : gift.code
    end
    
    def gift_name
      gift.nil? ? '' : gift.name
    end
    
    def total_quantity(item)
      item.quantity*self.quantity
    end
    
  end
end
