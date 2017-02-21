module Erp::Products
  class ProductsProperty < ApplicationRecord
    belongs_to :product
    belongs_to :property
    
    has_many :products_values, dependent: :destroy
    
    # Get property name
    def property_name
      property.nil? ? "" : property.name
    end
  end
end
