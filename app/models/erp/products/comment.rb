module Erp::Products
  class Comment < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    belongs_to :parent, class_name: "Erp::Products::Comment", optional: true
    has_many :children, class_name: "Erp::Products::Comment", foreign_key: "parent_id"
    validates :name, :email, :message, :presence => true
  end
end
