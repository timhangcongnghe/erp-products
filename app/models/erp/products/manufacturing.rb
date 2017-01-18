module Erp::Products
  class Manufacturing < ApplicationRecord
    validates :product_id, :quantity, :presence => true
    
    belongs_to :product, class_name: "Erp::Products::Product", foreign_key: :product_id
    belongs_to :responsible, class_name: "Erp::Contacts::Contact", foreign_key: :responsible_id, optional: true
    belongs_to :creator, class_name: "Erp::User"
    
    # class const
    STATUS_DRAFT = 'draft'
    STATUS_MANUFACTURING = 'manufacturing'
    STATUS_FINISHED = 'finished'
    
    # get status options for manufacturing
    def self.get_status_options()
      [
        {text: I18n.t('erp_products_manufacturings_draft'),value: self::STATUS_DRAFT},
        {text: I18n.t('erp_products_manufacturings_manufacturing'),value: self::STATUS_MANUFACTURING},
        {text: I18n.t('erp_products_manufacturings_finished'),value: self::STATUS_FINISHED}
      ]
    end
    
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
    
    # update status for manufacturing
    def draft
			update_columns(status: 'draft')
		end
    
    def manufacturing
			update_columns(status: 'manufacturing')
		end
    
    def finished
			update_columns(status: 'finished')
		end
    
    def self.draft_all
			update_all(status: 'draft')
		end
    
    def self.manufacturing_all
			update_all(status: 'manufacturing')
		end
    
    def self.finished_all
			update_all(status: 'finished')
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
