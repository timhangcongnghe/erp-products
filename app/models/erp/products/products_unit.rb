module Erp::Products
  class ProductsUnit < ApplicationRecord
    belongs_to :product
    belongs_to :unit
    
    validates :unit_id, :conversion_value, :presence => true
    
    # unit name
    def unit_name
			unit.present? ? unit.name : ''
		end
  end
end
