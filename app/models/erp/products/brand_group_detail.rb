module Erp::Products
  class BrandGroupDetail < ApplicationRecord
    belongs_to :brand_group, class_name: "Erp::Products::BrandGroup"
    belongs_to :brand, class_name: "Erp::Products::Brand"
  end
end
