module Erp::Products
  class Brand < ApplicationRecord
		mount_uploader :image_url, Erp::Products::BrandImageUploader

		validates :name, uniqueness: true
    validates :name, presence: true

    belongs_to :creator, class_name: 'Erp::User'
    has_many :products, class_name: 'Erp::Products::Product', dependent: :destroy
    has_many :brand_group_details, class_name: 'Erp::Products::BrandGroupDetail', dependent: :destroy

    #START FOR FRONTEND
    def self.get_active
		  self.where(archived: false)
		end

    def self.get_laptop_brands
      # Microsoft #9, Apple #16, HP #5, Dell #3, Lenovo #2, MSI #31, Asus #41, Acer #1, Gigabyte #56, Avita #194, Dynabook #199
      arr = [16, 5, 3, 2, 31, 41, 1, 56, 194, 199, 9]
      return where(id: arr).get_active.order('name asc')
    end

    def get_products_home_page
      products.get_active.order('created_at desc').limit(6)
    end
    #END FOR FRONTEND
    
    def get_name
      name
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
      query = query.joins(:creator)
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
        query = query.where('LOWER(cache_search) LIKE ?', "%#{keyword}%")
      end
      query = query.limit(8).map{|brand| {value: brand.id, text: brand.get_name}}
    end

    after_create :create_alias
    after_save :update_cache_search

    def create_alias
      name = self.name
      self.update_column(:alias, name.to_ascii.downcase.to_s.gsub(/[^0-9a-z \/\-\.]/i, '').gsub(/[ \/\.]+/i, '-').strip)
    end

		def update_cache_search
			str = []
			str << name.to_s.downcase.strip
			self.update_column(:cache_search, str.join(' ') + ' ' + str.join(' ').to_ascii)
		end
  end
end