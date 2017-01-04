module Erp::Products
  class PropertiesValue < ApplicationRecord
    belongs_to :property
    
    validates :value, :presence => true
    
    # Get property name
    def property_name
      property.nil? ? "" : property.name
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='', params={})
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(value) LIKE ?', "%#{keyword}%")
      end
      
      if params[:current_value].present?
        query = query.where.not(id: params[:current_value].split(','))
      end
      
      query = query.limit(8).map{|properties_value| {value: properties_value.id, text: properties_value.value} }
    end
  end
end
