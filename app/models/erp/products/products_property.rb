module Erp::Products
  class ProductsProperty < ApplicationRecord
    belongs_to :product, dependent: :destroy
    belongs_to :property, dependent: :destroy
    
    has_many :products_values
    
    # Get property name
    def property_name
      property.nil? ? "" : property.name
    end
  end
end
