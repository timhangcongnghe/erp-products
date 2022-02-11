module Erp::Products
  class Property < ApplicationRecord
		include Erp::CustomOrder

    validates :name, :property_group_id, :presence => true

    belongs_to :creator, class_name: 'Erp::User'
    belongs_to :property_group, class_name: 'Erp::Products::PropertyGroup'
    has_many :properties_values, class_name: 'Erp::Products::PropertiesValue', dependent: :destroy

    def get_name
			name
		end

    def get_property_group_name
			property_group.present? ? property_group.get_name : ''
		end

    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
			if params['filters'].present?
				params['filters'].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						or_conds << "#{cond[1]['name']} = '#{cond[1]['value']}'"
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
      query = query.joins(:creator).joins(:property_group)
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
      query = query.limit(30).map{|property| {value: property.id, text: ("#{property.get_property_group_name} / ") + property.get_name}}
    end
  end
end