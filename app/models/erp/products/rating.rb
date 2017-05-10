module Erp::Products
  class Rating < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    belongs_to :user, class_name: 'Erp::User'
    
    validates :star, :presence => true
    validates :content, length: { minimum: 50 }
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
			
			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
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
      
      # join with products table for search product
      query = query.joins(:product)

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
    
    def archive
			update_columns(archived: true)
		end
		
		def unarchive
			update_columns(archived: false)
		end
    
    def self.archive_all
			update_all(archived: true)
		end
    
    def self.unarchive_all
			update_all(archived: false)
		end
    
    # display product name
    def product_name
			product.present? ? product.name : ''
		end
    
    # display user name
    def user_name
			user.present? ? user.name : ''
		end
    
    # display user email
    def user_email
			user.present? ? user.email : ''
		end
    
    # display message rating
    def display_content
			content.gsub("\r\n", "<br/>").html_safe
		end
    
    # ratings count archived
    def self.count_archived
			self.where(archived: true).count
		end
  end
end
