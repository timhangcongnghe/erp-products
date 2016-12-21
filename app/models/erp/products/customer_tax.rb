module Erp::Products
  class CustomerTax < ApplicationRecord
    belongs_to :product
    belongs_to :tax
  end
end
