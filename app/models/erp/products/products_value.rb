module Erp::Products
  class ProductsValue < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    belongs_to :properties_value, class_name: 'Erp::Products::PropertiesValue'
    validates_uniqueness_of :properties_value_id, scope: :product_id
  end
end