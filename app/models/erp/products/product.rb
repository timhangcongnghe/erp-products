module Erp::Products
  class Product < ApplicationRecord
    validates :name, :category_id, :presence => true
    
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category
    if Erp::Core.available?("taxes")
      has_and_belongs_to_many :customer_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_customer_taxes'
			has_and_belongs_to_many :vendor_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_vendor_taxes'
    end
    
    # get type options for product
    def self.get_product_type_options()
      [
				{text: '',value: false},
        {text: I18n.t('consumable'), value: 'consumable'},
        {text: I18n.t('service'), value: 'service'},
        {text: I18n.t('product'), value: 'product'}
      ]
    end
    
    # get invoicing policy for product
    def self.get_invoicing_policy_options()
      [
        {text: I18n.t('ordered_quantities'), value: 'ordered_quantities'},
        {text: I18n.t('delivered_quantities'), value: 'delivered_quantities'}
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
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|product| {value: product.id, text: product.name} }
    end
    
    def self.archive_all
			update_all(archived: false)
		end
    
    def self.unarchive_all
			update_all(archived: true)
		end
    
    # category name
    def category_name
			category.present? ? category.name : ''
		end
  end
end
