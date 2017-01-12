module Erp::Products
  class PriceList < ApplicationRecord
    validates :name, :presence => true
    
    belongs_to :creator, class_name: "Erp::User"
    if Erp::Core.available?("warehouses")
      has_and_belongs_to_many :warehouses, class_name: 'Erp::Warehouses::Warehouse', :join_table => 'erp_products_price_lists_warehouses'
    end
    #if Erp::Core.available?("contacts")
    #  has_and_belongs_to_many :contact_groups, class_name: 'Erp::Contacts::ContactGroup', :join_table => 'erp_contact_groups_price_lists'
    #end
    
    has_and_belongs_to_many :price_lists_users, class_name: 'Erp::User', :join_table => 'erp_products_price_lists_users'
    
    # get type options for contact
    def self.get_status_options()
      [
        {text: I18n.t('.active'),value: true},
        {text: I18n.t('.inactive'),value: false}
      ]
    end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      # show active items condition - default: true
			show_active = true
			
			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						# in case filter is show active
						if cond[1]["name"] == 'show_active'
							# show active items
							show_active = false
						else
							or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
						end
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end
      
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
      
      # join with users table for search creator
      query = query.joins(:creator)
      
      # showing active items if show_active is not true
			query = query.where(active: true) if show_active == true

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        
        query = query.order(order)
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|price_list| {value: price_list.id, text: price_list.name} }
    end
    
    def disable
			update_columns(active: false)
		end
		
		def enable
			update_columns(active: true)
		end
    
    def self.disable_all
			update_all(active: false)
		end
    
    def self.enable_all
			update_all(active: true)
		end
    
    def valid_from_date
      valid_from.present? ? valid_from.strftime("%d/%m/%Y %I:%M") : ""
    end
    
    def valid_to_date
      valid_to.present? ? valid_to.strftime("%d/%m/%Y %I:%M") : ""
    end
  end
end
