module Erp::Products
  class ProductsValue < ApplicationRecord
    belongs_to :properties_value
    belongs_to :product

    validates_uniqueness_of :properties_value_id, :scope => :product_id
  end
end
