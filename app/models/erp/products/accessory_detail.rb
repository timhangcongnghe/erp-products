module Erp::Products
  class AccessoryDetail < ApplicationRecord
    belongs_to :accessory, class_name: "Erp::Products::Accessory"
    belongs_to :product, class_name: "Erp::Products::Product"
    
    def accessory_name
      accessory.name
    end
  end
end
