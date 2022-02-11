module Erp::Products
  class CategoriesPgroup < ApplicationRecord    
    belongs_to :category, class_name: 'Erp::Products::Category'
    belongs_to :property_group, class_name: 'Erp::Products::PropertyGroup'
  end
end