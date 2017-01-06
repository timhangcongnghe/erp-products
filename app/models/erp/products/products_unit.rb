module Erp::Products
  class ProductsUnit < ApplicationRecord
    belongs_to :product
    belongs_to :unit
  end
end
