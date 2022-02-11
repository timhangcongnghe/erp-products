module Erp::Products
  class PropertyGroup < ApplicationRecord
		include Erp::CustomOrder

    validates :name, presence: true
    validates :show_name, presence: true

    belongs_to :creator, class_name: 'Erp::User'
    has_many :properties, -> {order 'erp_products_properties.custom_order'}, class_name: 'Erp::Products::Property', dependent: :destroy
    has_and_belongs_to_many :categories, class_name: 'Erp::Products::Category', join_table: 'erp_products_categories_pgroups'

    def get_name
			name
		end
    
    def get_show_name
			show_name
		end

    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      if params['keywords'].present?
        params['keywords'].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]['name']}) LIKE '%#{cond[1]['value'].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
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
      query = query.limit(8).map{|property_group| {value: property_group.id, text: property_group.get_name} }
    end
  end
end