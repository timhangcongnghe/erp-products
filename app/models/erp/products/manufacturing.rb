module Erp::Products
  class Manufacturing < ApplicationRecord
    validates :product_id, :quantity, :presence => true
    
    belongs_to :product, class_name: "Erp::Products::Product", foreign_key: :product_id
    belongs_to :responsible, class_name: "Erp::Contacts::Contact", foreign_key: :responsible_id, optional: true
    belongs_to :creator, class_name: "Erp::User"
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.order("created_at DESC")
      query = self.filter(query, params)
      
      return query
    end
    
    def products_parts
			if self.product.present?
				self.product.products_parts
			end
		end
    
    # responsible name
    def responsible_name
      responsible.present? ? responsible.name : ''
    end
    
    # product name
    def product_name
      product.present? ? product.name : ''
    end
  end
end
