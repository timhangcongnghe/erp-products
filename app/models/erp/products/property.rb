module Erp::Products
  class Property < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    
    validates :name, :presence => true
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|property| {value: property.id, text: property.name} }
    end
  end
end
