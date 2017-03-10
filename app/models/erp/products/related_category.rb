module Erp::Products
  class RelatedCategory < ApplicationRecord
    belongs_to :parent, class_name: "Erp::Products::Category", foreign_key: "parent_id"
    belongs_to :category, class_name: "Erp::Products::Category", foreign_key: "category_id"
  end
end
