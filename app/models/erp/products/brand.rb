module Erp::Products
  class Brand < ApplicationRecord
		mount_uploader :image_url, Erp::Products::BrandImageUploader
		validates :name, :uniqueness => true
    validates :name, :presence => true
    has_many :brand_group_details, class_name: 'Erp::Products::BrandGroupDetail', dependent: :destroy
    belongs_to :creator, class_name: "Erp::User"

    def self.get_active
			self.where(archived: false)
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
      query = query.joins(:creator)

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

      query = query.limit(8).map{|brand| {value: brand.id, text: brand.name} }
    end

    def self.get_brands
			self.where(archived: false).order("created_at DESC")
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

    def self.get_brands_order_name
			self.get_active.where(is_main: true).order('name ASC')
		end

    def self.get_brands
			self.get_active.order('name ASC')
		end

    # search by keyword
    def self.filter_by_keyword(kw)
			query = self.where("1=1")
			# single keyword
      if kw.present?
				keyword = kw.strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(cache_search) LIKE ?', '%'+q+'%')
				end
			end

      return query
		end

    # select result
    def self.select2(params=nil, limit=40)
			query = self.order('name asc')
			query = query.filter_by_keyword(params[:q]) if params[:q].present?
			query = query.limit(limit)

			return query.map{|brand| {value: brand.id, text: brand.name}}
		end

    # Update cache search for brands
    after_save :update_cache_search

		def update_cache_search
			str = []
			str << name.to_s.downcase.strip

			self.update_column(:cache_search, str.join(" ") + " " + str.join(" ").to_ascii)
		end

		def self.for_filter
			self.get_active.order('name asc')
		end

  end
end
