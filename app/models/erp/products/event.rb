module Erp::Products
  class Event < ApplicationRecord
    validates :name, :from_date, :to_date, :presence => true
    mount_uploader :image_url, Erp::Products::EventImageUploader
    
    belongs_to :creator, class_name: "Erp::User"
    has_and_belongs_to_many :products
    
    has_many :events_products, dependent: :destroy
    accepts_nested_attributes_for :events_products, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
    
    def self.events_active
      self.where(archived: false)
    end
    
    def self.search(params)
      self.events_active
    end
    
    # get future events
    def self.get_future_events
      self.events_active.where("from_date >= ?", Time.now)
                        .order("from_date DESC")
    end
    
    # get current events
    def self.get_current_events
      self.events_active.where("from_date <= ? and to_date >= ?", Time.now, Time.now)
                        .order("from_date DESC")
    end
    
    # get past events
    def self.get_past_events
      self.events_active.where("to_date <= ?", Time.now)
                        .order("from_date DESC")
    end
  end
end
