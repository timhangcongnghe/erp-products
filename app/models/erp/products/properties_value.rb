module Erp::Products
  class PropertiesValue < ApplicationRecord
    belongs_to :property, dependent: :destroy
    
    validates :value, :presence => true, uniqueness: true
    
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
      
      # filter by parent
      if params[:parent_value].present?
				query = query.where(params[:parent_id] => params[:parent_value])
			end
      
      query = query.limit(8).map{|properties_value| {value: properties_value.id, text: properties_value.value} }
    end
    
    def self.create_if_not_exists(prop_id, name)
        exist = PropertiesValue.where(property_id: prop_id).where(value: name).first
        if !exist.present?
            exist = PropertiesValue.create(property_id: prop_id, value: name)
        end
        return exist
    end
  end
end
