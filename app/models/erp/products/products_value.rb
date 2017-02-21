module Erp::Products
  class ProductsValue < ApplicationRecord
    belongs_to :properties_value
    belongs_to :products_property
    
    validates_uniqueness_of :properties_value_id, :scope => :products_property_id
    
    def self.create_if_not_exists(products_value)
			exist = self.where(properties_value_id: products_value[:properties_value_id])
                  .where(products_property_id: products_value[:products_property_id]).first
			if !exist.present?
				exist = ProductsValue.create(properties_value_id: products_value[:properties_value_id],
          products_property_id: products_value[:products_property_id]
        )
			end
			
			return exist
    end
  end
end
