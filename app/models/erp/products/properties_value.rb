module Erp::Products
  class PropertiesValue < ApplicationRecord
    belongs_to :property
    has_many  :products_values, dependent: :destroy

    validates :value, :presence => true
    validates :property_id, :presence => true
    validate :value_check

    def value_check
			exist = PropertiesValue.where.not(id: self.id).where(property_id: self.property_id).where('LOWER(value) = ?', self.value.strip.downcase).first
			if exist.present?
				errors.add(:value)
			end
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

      query = query.limit(8).map{|properties_value| {value: properties_value.id, text: properties_value.value} }
    end

    def self.create_if_not_exists(prop_id, name)
			exist = self.where(property_id: prop_id).where('LOWER(value) = ?', name.strip.downcase).first
			if !exist.present?
				exist = PropertiesValue.create(property_id: prop_id, value: name)
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
  end
end
