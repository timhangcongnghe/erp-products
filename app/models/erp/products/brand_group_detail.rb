module Erp::Products
  class BrandGroupDetail < ApplicationRecord
    belongs_to :brand_group, class_name: "Erp::Products::BrandGroup"
    belongs_to :brand, class_name: "Erp::Products::Brand"
    
    def brand_name
      brand.name
    end
  end
end
