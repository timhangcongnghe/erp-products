module Erp::Products
  class StockCheckDetail < ApplicationRecord
    belongs_to :product
    belongs_to :stock_check, inverse_of: :stock_check_details
    belongs_to :state, class_name: "Erp::Products::State"
    validates :stock_check, presence: true
    
    def product_code
      product.nil? ? '' : product.code
    end
    
    def product_name
      product.nil? ? '' : product.name
    end
    
    def state_name
      state.nil? ? '' : state.name
    end
  end
end
