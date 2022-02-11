module Erp::Products
  class Accessory < ApplicationRecord
    validates :name, presence: true

    belongs_to :creator, class_name: 'Erp::User'
    has_many :accessory_details, class_name: 'Erp::Products::AccessoryDetail', dependent: :destroy
    accepts_nested_attributes_for :accessory_details, reject_if: lambda {|a| a[:product_id].blank? }, allow_destroy: true
    
    def get_name
			name
		end

    def get_accessory_details
			accessory_details.order('created_at DESC')
		end

    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
			show_archived = false
			if params['filters'].present?
				params['filters'].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						if cond[1]['name'] == 'show_archived'
							show_archived = true
						else
							or_conds << "#{cond[1]['name']} = '#{cond[1]['value']}'"
						end
					end
					and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
				end
			end
      if params['keywords'].present?
        params['keywords'].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]['name']}) LIKE '%#{cond[1]['value'].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      query = query.joins(:creator)
			if show_archived == true
        query = query.where(archived: true)
      else
        query = query.where(archived: false)
      end
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        query = query.order(order)
      end
      return query
    end
    
    def self.dataselect(keyword='')
      query = self.all
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      query = query.limit(8).map{|accessory| {value: accessory.id, text: accessory.get_name}}
    end
    
    def archive
			update_columns(archived: true)
		end
		
		def unarchive
			update_columns(archived: false)
		end
  end
end