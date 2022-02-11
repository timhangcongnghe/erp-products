module Erp::Products
  class ProductsProperty < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    belongs_to :property, class_name: 'Erp::Products::Property'
    has_many :products_values, class_name: 'Erp::Products::ProductsValue', dependent: :destroy
    def get_property_name
      property.nil? ? ' ' : property.get_name
    end
  end
end