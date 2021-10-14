module Erp::Products
  class PropertiesValue < ApplicationRecord
		include Erp::CustomOrder

    belongs_to :property
    has_many  :products_values, dependent: :destroy
    has_many :products, through: :products_values, class_name: 'Erp::Products::Product'
    has_many :products, through: :products_values

    validates :value, :presence => true
    validates :property_id, :presence => true
    validate :value_check

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

    def self.get_property_values_for_filter
			self.order("value asc")
		end

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

      if params[:property_id].present?
				query = query.where(property_id: params[:property_id])
			end

			if params[:group_by_property].present?
				query = query.where(property_id: params[:group_by_property])
			end

      query = query.order(:value).map{|properties_value| {value: properties_value.id, text: properties_value.value} }
    end

    def self.create_if_not_exists(prop_id, name)
			exist = self.where(property_id: prop_id).where('LOWER(value) = ? OR value = ? OR UPPER(value) = ?', name.strip.downcase, name.strip, name.strip.upcase).first
			if !exist.present?
				exist = PropertiesValue.create(property_id: prop_id, value: name.strip)
			end
			return exist
    end

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

      # join with users table for search creator
      query = query.joins(:property)

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

    def property_name
			property.nil? ? '' : property.name
		end

    def property_group_name
			property.nil? ? '' : (property.property_group.nil? ? '' : property.property_group.name)
		end

    def product_count
			Erp::Products::ProductsValue.where(properties_value: self.id).count
		end

    def product_count_by_menu(menu)
			Erp::Products::ProductsValue.includes(:product)
        .where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first})
        .where(properties_value: self.id).count
		end

    def product_count_by_menu_brand(menu)
			Erp::Products::ProductsValue.includes(:product)
        .where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first, brand_id: menu.brand.id})
        .where(properties_value: self.id).count
		end
  end
end
