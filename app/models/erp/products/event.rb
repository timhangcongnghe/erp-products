module Erp::Products
  class Event < ApplicationRecord
    validates :name, :from_date, :to_date, :presence => true
    mount_uploader :image_url, Erp::Products::EventImageUploader
    
    belongs_to :creator, class_name: "Erp::User"
    has_and_belongs_to_many :products
    
    has_many :events_products, dependent: :destroy
    accepts_nested_attributes_for :events_products, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
    
    def self.search(params)
      self.where(archived: false)
    end
  end
end
