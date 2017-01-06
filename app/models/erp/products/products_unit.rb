module Erp::Products
  class ProductsUnit < ApplicationRecord
    belongs_to :product
    belongs_to :unit
    
    # unit name
    def unit_name
			unit.present? ? unit.name : ''
		end
  end
end
