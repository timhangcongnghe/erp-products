module Erp::Products
  class StateCheckDetail < ApplicationRecord
    validates :product_id, :state_id, :quantity, presence: true
    belongs_to :state, class_name: "Erp::Products::State"
    belongs_to :product, class_name: "Erp::Products::Product"
    belongs_to :state_check, class_name: "Erp::Products::StateCheck"
    
    after_save :update_product_cache_stock

    # update product cache stock
    def update_product_cache_stock
			self.product.update_cache_stock if self.product.present?
		end
    
    def get_product_name
      product.present? ? product.name : ''
    end
    
    def get_product_code
      product.present? ? product.code : ''
    end
    
    def get_state_name
      state.present? ? state.name : ''
    end
    
  end
end
