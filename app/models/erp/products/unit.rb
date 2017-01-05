module Erp::Products
  class Unit < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    
    validates :name, :presence => true
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|unit| {value: unit.id, text: unit.name} }
    end
  end
end
