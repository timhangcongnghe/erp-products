module Erp::Products
  class Rating < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    validates :name, :email, :content, :star, :presence => true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  end
end
