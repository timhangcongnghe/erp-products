module Erp::Products
  class DamageRecordDetail < ApplicationRecord
    belongs_to :product
    belongs_to :damage_record, inverse_of: :damage_record_details
    belongs_to :state
    validates :damage_record, presence: true
    
    after_save :update_product_cache_stock

    # update product cache stock
    def update_product_cache_stock
			self.product.update_cache_stock if self.product.present?
		end
    
    def product_code
      product.nil? ? '' : product.code
    end
    
    def product_name
      product.nil? ? '' : product.name
    end
    
    def product_unit
      product.nil? ? '' : product.unit_name
    end
    
    def state_name
      state.nil? ? '' : state.name
    end
  end
end
