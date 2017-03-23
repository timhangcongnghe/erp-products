module Erp::Products
  class Rating < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    validates :name, :email, :content, :star, :presence => true
  end
end
