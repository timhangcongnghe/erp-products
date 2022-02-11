module Erp::Products
  class AccessoryDetail < ApplicationRecord
    belongs_to :accessory, class_name: 'Erp::Products::Accessory'
    belongs_to :product, class_name: 'Erp::Products::Product'

    def get_accessory_name
      accessory.get_name
    end

    def get_product_name
      product.get_name
    end
  end
end