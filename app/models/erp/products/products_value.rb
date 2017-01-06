module Erp::Products
  class ProductsValue < ApplicationRecord
    belongs_to :properties_value, dependent: :destroy
    belongs_to :products_property, dependent: :destroy
    
    validates_uniqueness_of :properties_value_id, :scope => :products_property_id
  end
end
