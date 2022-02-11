module Erp::Products
  class Category < ApplicationRecord
		include Erp::CustomOrder

		validates :name, presence: true

    belongs_to :creator, class_name: 'Erp::User'
		has_many :products, class_name: 'Erp::Products::Product', dependent: :destroy
    belongs_to :parent, class_name: 'Erp::Products::Category', optional: true
    has_many :children, class_name: 'Erp::Products::Category', foreign_key: 'parent_id'
    has_and_belongs_to_many :property_groups, -> {order 'erp_products_property_groups.custom_order'}, class_name: 'Erp::Products::PropertyGroup', join_table: 'erp_products_categories_pgroups'
		has_and_belongs_to_many :menus, class_name: 'Erp::Menus::Menu'

    #START FOR FRONTEND
    def get_products_home_page
      products.get_active.order('created_at desc').limit(6)
    end

    def get_self_and_children_ids
      ids = [self.id]
      ids += get_children_ids_recursive
      return ids
    end
    
    def get_children_ids_recursive
      ids = []
      children.each do |c|
        if !c.children.empty?
          ids += c.get_children_ids_recursive
        end
        ids << c.id
      end
      return ids
    end

    def category_get_properties_array
      groups = []
      return [] if nil?
      property_group = property_groups.where(is_filter_specs: true).first
      property_group.properties.each do |property|
        row = {}
        row[:name] = property.get_name
        row[:values] = []
        if property.use_custom_sort?
          values = property.properties_values.order('custom_sort ASC').get_property_values_for_filter.map {|pv| pv}
        else
          values = property.properties_values.order('custom_order ASC').get_property_values_for_filter.map {|pv| pv}
        end
        row[:values] += values if !values.empty?
        groups << row if !row[:values].empty?
      end
      return groups
    end
    #END FOR FRONTEND

    def get_product_count
			products.count
		end

    def get_name
      name
    end

    def get_full_name
			names = [self.get_name]
			p = self.parent
			while !p.nil? do
				names << p.get_name
				p = p.parent
			end
			names.reverse.join(' >> ')
		end

    def get_parent_name
			parent.present? ? parent.get_name : ''
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
      query = query.joins('LEFT JOIN erp_products_categories parents_erp_products_categories ON parents_erp_products_categories.id = erp_products_categories.parent_id')
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

    def self.dataselect(keyword='', params={})
      query = self.all
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      query = query.limit(20).map{|category| {value: category.id, text: (category.get_parent_name.empty? ? '' : "#{category.get_parent_name} / ") + category.get_name}}
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

    after_save :update_level

    def update_level
			level = 1
			parent = self.parent
			while parent.present?
				level += 1
				parent = parent.parent
			end
			level
		end
  end
end