module Erp::Products
  class PropertiesValue < ApplicationRecord
		include Erp::CustomOrder

    validates :value, presence: true
    validates :property_id, presence: true
    validate :value_check

    belongs_to :property, class_name: 'Erp::Products::Property'
    has_many  :products_values, class_name: 'Erp::Products::ProductsValue', dependent: :destroy
    has_many :products, through: :products_values, class_name: 'Erp::Products::Product'
    has_many :products, through: :products_values
    has_and_belongs_to_many :menus, class_name: 'Erp::Menus::Menu', join_table: 'erp_menus_menus_properties_values'

    #START FOR FRONTEND
    def self.get_property_values_for_filter
      order('value asc')
    end

    def product_count_by_menu(menu)
      Erp::Products::ProductsValue.includes(:product).where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first}).where(properties_value: id).count
    end

    def product_count_by_menu_brand(menu)
      Erp::Products::ProductsValue.includes(:product).where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first, brand_id: menu.brand_id}).where(properties_value: id).count
    end
    #END FOR FRONTEND

    def get_value
			value
		end

    def get_property_name
			property.nil? ? '' : property.get_name
		end

    def get_property_group_name
			property.nil? ? '' : (property.property_group.nil? ? '' : property.property_group.get_name)
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
      query = query.joins(:property)
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      return query
    end

    def self.search(params)
      query = self.order('value asc')
      query = self.filter(query, params)
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        query = query.order(order)
      end
      return query
    end

    def self.dataselect(keyword='',params={})
      query = self.order('value asc')
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(value) LIKE ?', "%#{keyword}%")
      end
      if params[:current_value].present?
        query = query.where.not(id: params[:current_value].split(','))
      end
      if params[:parent_value].present?
				query = query.where(params[:parent_id] => params[:parent_value])
			end
      if params[:property_id].present?
				query = query.where(property_id: params[:property_id])
			end
      if params[:group_by_property].present?
				query = query.where(property_id: params[:group_by_property])
			end
      query = query.order(:value).map{|properties_value| {value: properties_value.id, text: properties_value.get_value}}
    end

    def self.dataselect_for_menu(keyword='',params={})
      query = self.order('value asc')
      query = query.order(:value).limit(20).map{|properties_value| {value: properties_value.id, text: (properties_value.property.nil? ? '' : "#{properties_value.property.get_property_group_name} / " + "#{properties_value.get_property_name} / ") + properties_value.get_value}}
    end

    after_save :update_custom_sort
    def update_custom_sort
      self.update_column(:custom_sort, self.property_id.to_s + self.id_sort.to_s)
    end

    def value_check
			exist = PropertiesValue.where.not(id: self.id).where(property_id: self.property_id).where('value = ?', self.value).first
			if exist.present?
				errors.add(:value)
			end
		end

    def self.create_if_not_exists(prop_id, name)
			exist = self.where(property_id: prop_id).where('LOWER(value) = ? OR value = ? OR UPPER(value) = ?', name.strip.downcase, name.strip, name.strip.upcase).first
			if !exist.present?
				exist = PropertiesValue.create(property_id: prop_id, value: name.strip)
			end
			return exist
    end
  end
end