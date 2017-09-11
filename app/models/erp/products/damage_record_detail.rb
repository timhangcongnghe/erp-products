module Erp::Products
  class DamageRecordDetail < ApplicationRecord
    belongs_to :product
    belongs_to :damage_record, inverse_of: :damage_record_details
    belongs_to :state
    validates :damage_record, presence: true
    
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
