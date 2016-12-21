module Erp::Products
  class VendorTax < ApplicationRecord
    belongs_to :product
    belongs_to :tax
  end
end
