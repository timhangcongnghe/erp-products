module Erp::Products
  class Property < ApplicationRecord
		include Erp::CustomOrder

    validates :name, :property_group_id, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :property_group, class_name: "Erp::Products::PropertyGroup"
    has_many :properties_values

    def self.get_active
			self.where(archived: false)
		end

    def self.get_properties_for_filter
			self.where(archived: false)
					.where(is_show_website: true).order("custom_order asc")
		end

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      # show archived items condition - default: false
			show_archived = false

			#filters
			if params["filters"].present?
				params["filters"].each do |ft|
					or_conds = []
					ft[1].each do |cond|
						# in case filter is show archived
						if cond[1]["name"] == 'show_archived'
							# show archived items
							show_archived = true
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
      query = query.joins(:creator).joins(:property_group)

      # showing archived items if show_archived is not true
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

      query = query.limit(30).map{|property| {value: property.id, text: ("#{property.property_group_name} / ") + property.name} }
    end

    # property group name
    def property_group_name
			property_group.present? ? property_group.name : ''
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
  end
end
