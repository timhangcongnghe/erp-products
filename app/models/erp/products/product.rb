module Erp::Products
  class Product < ApplicationRecord
		validates :name, presence: true
		#validates :name, uniqueness: true
		validates :short_name, presence: true
    validates :category_id, presence: true
		#validates :custom_title, presence: true
		#validates :custom_alias, presence: true
    validate :deal_to_date_cannot_be_in_the_past, :deal_price_cannot_blank

		attr_accessor :product_property_values

    belongs_to :creator, class_name: 'Erp::User'
    belongs_to :category, class_name: 'Erp::Products::Category'
    belongs_to :brand, class_name: 'Erp::Products::Brand'
		belongs_to :accessory, class_name: 'Erp::Products::Accessory', optional: true
    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, reject_if: lambda {|a| a[:image_url].blank? and a[:image_url_cache].blank?}, allow_destroy: true
    has_many :order_details, class_name: 'Erp::Orders::OrderDetail'
		has_many :products_values, -> {order 'erp_products_products_values.id'}, dependent: :destroy

		has_many :products_gifts, dependent: :destroy
    accepts_nested_attributes_for :products_gifts, reject_if: lambda {|a| a[:gift_id].blank?}, allow_destroy: true
    has_many :gifts, through: :products_gifts, class_name: 'Erp::Products::Product', foreign_key: :gift_id

		#START FOR FRONTEND
    def self.get_active
			where(archived: false, is_sold_out: false)
		end

		def self.get_newest_products
			return get_active.order('created_at desc').where(is_new: true).limit(10)
		end

		def self.get_computer_components
			arr = [100, 127, 128, 214, 215, 10, 56, 210, 211]
			return get_active.order('created_at desc').joins(:category).where('erp_products_categories.id': arr).limit(6)
		end
		
		def self.get_computer_accessories
			arr = [14, 12, 4, 65, 219, 141, 104, 57, 236]
			return get_active.order('created_at desc').joins(:category).where('erp_products_categories.id': arr).limit(6)
		end
		
		def self.get_network_products
			arr = [50, 132, 69]
			return get_active.order('created_at desc').joins(:category).where('erp_products_categories.id': arr).limit(6)
		end
		
		def self.get_printer_products
			arr = [221, 237, 82]
			return get_active.order('created_at desc').joins(:category).where('erp_products_categories.id': arr).limit(6)
		end

		def get_main_image
			img = get_all_images.first
			return img.nil? ? Erp::Products::ProductImage.new : img
		end

		def get_all_images
			product_images.where.not(image_url: nil).order('id desc')
		end

		def find_menu
			if !find_all_menus.nil?
				all_menus = find_all_menus
				if brand_id?
					menus = all_menus.where(brand_id: brand_id)
				end
				menus = all_menus if menus.empty?
				menus.last
			end
		end

		def find_all_menus
			category.nil? ? nil : category.menus
		end

		def self.brand_related_products_for_not_sold_out(product)
			where(category_id: product.category, is_sold_out: false).where(brand_id: product.brand).where.not(id: product).order('erp_products_products.created_at desc')
		end

		def self.category_related_products_for_not_sold_out(product)
			where(category_id: product.category, is_sold_out: false).where.not(id: product).order('erp_products_products.created_at desc')
		end

		def self.category_newest_related_products(product)
			where(category_id: product.category, is_new: true).where(brand_id: product.brand).where.not(id: product).order('erp_products_products.created_at desc')
		end

		def product_long_descipriton_values_array
			groups = []
			return [] if category.nil? || category.property_groups.count == 0
			property_group = category.property_groups
			property_group.where(is_filter_specs: false).each do |group|
				row = {}
				row[:group] = group
				row[:properties] = []
				group.properties.each do |property|
					row2 = {}
					row2[:property] = property
					row2[:values] = products_values_by_property(property).map {|pv| pv.properties_value.value }
					row[:properties] << row2 if !row2[:values].empty?
				end
				groups << row if !row[:properties].empty?
			end
			return groups
		end

		def get_product_discount_price
			return get_listed_price - get_show_price
		end

		def get_product_discount_percent
			return 0 if get_listed_price.to_f == 0
			((get_listed_price.to_f - get_show_price.to_f)/get_listed_price.to_f) * 100
		end
    #END FOR FRONTEND

		def get_code
			code.present? ? code : ''
		end
		
		def get_name
			name
		end

		def get_short_name
			short_name
		end
	
		def get_custom_title
			custom_title
		end

		def get_breadcrumb_name
			if get_custom_title.present?
				return get_custom_title
			elsif get_short_name
				return get_short_name
			else
				get_name
			end
		end

		def get_custom_alias
			custom_alias
		end
		
		def get_brand_name
			brand.present? ? brand.get_name : ''
		end
		
		def get_category_name
			category.present? ? category.get_name : ''
		end

		def get_accessory_name
			accessory.present? ? accessory.get_name : ''
		end

		def get_price
			price.present? ? price : ''
		end

		def get_deal_price
			deal_price.present? ? deal_price : ''
		end

		def get_listed_price
			listed_price.present? ? listed_price : ''
		end

		def get_show_price
			return get_price #if !is_deal
			# from_conds = !deal_from_date.present? || (deal_from_date.present? && Time.now >= deal_from_date.beginning_of_day)
			# to_conds = !deal_to_date.present? || (deal_to_date.present? && Time.now <= deal_to_date.end_of_day)
			# if from_conds && to_conds
			# 	return get_deal_price
			# else
			# 	update_column(:is_deal, false)
			# 	return get_price
			# end
		end

		def get_warranty
			warranty.present? ? warranty : ''
		end

		def get_weights
			weights.present? ? weights : ''
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
				params["keywords"].each do |kw|
					or_conds = []
					kw[1].each do |cond|
						or_conds << "LOWER(#{cond[1]['name']}) LIKE '%#{cond[1]['value'].downcase.strip}%'"
					end
					and_conds << '('+or_conds.join(' OR ')+')'
				end
			end
			global_filter = params[:global_filter]
			if global_filter.present?
				@global_filters = global_filter
				brand_ids = @global_filters[:brands].present? ? @global_filters[:brands] : nil
				@brands = Erp::Products::Brand.where(id: brand_ids)
				category_ids = @global_filters[:categories].present? ? @global_filters[:categories] : nil
				@categories = Erp::Products::Category.where(id: category_ids)
				query = query.where(brand_id: brand_ids) if brand_ids.present?
				query = query.where(category_id: category_ids) if category_ids.present?
			end

			query = query.joins(:brand)
			query = query.joins(:category)
	
			if show_archived == true
				query = query.where(archived: true)
			else
				query = query.where(archived: false)
			end
	
			query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

			if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip        
					query = query.where('LOWER(erp_products_products.cache_search) LIKE ? OR LOWER(erp_products_products.cache_search) LIKE ? OR LOWER(erp_products_products.cache_search) LIKE ?', q+'%', '% '+q+'%', '%-'+q+'%')
				end
			end

			if params[:menu_id].present?
				menu = Erp::Menus::Menu.find(params[:menu_id])
				query = query.where(category_id: menu.get_all_related_category_ids)
			end
	
			return query
		end

		def self.search(params)
      query = self.all
      query = self.filter(query, params)
      return query.set_order(params)
    end

		def self.set_order(params)
			if params[:sort_by].present?
				order = params[:sort_by]
				order += " #{params[:sort_direction]}" if params[:sort_direction].present?
				query = self.order(order)
			else
				query = self.order('created_at desc')
			end
			return query
		end

		def self.dataselect(keyword='', params={})
      query = self.all
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(cache_search) LIKE ?', "%#{keyword}%")
      end
      query = query.limit(10).map{|product| {value: product.id, text: product.get_name}}
    end

		def copy(options={})
			new_product = Erp::Products::Product.create(self.attributes.merge({id: nil, created_at: nil, updated_at: nil, code: "#{self.code} (Copy from ##{self.id})", name: "#{self.name} (Copy from ##{self.id})", creator: options[:creator]}))
			self.products_values.each do |products_value|
				new_product.products_values.create(products_value.attributes.merge({id: nil}))
			end
			self.products_gifts.each do |products_gift|
				new_product.products_gifts.create(products_gift.attributes.merge({id: nil}))
			end
			new_product.save_meta_description
			#new_product.save_short_description
			return new_product
		end

		def products_values_by_property(property)
			self.products_values.joins(:properties_value).where(erp_products_properties_values: {property_id: property.id})
		end

		def deal_to_date_cannot_be_in_the_past
			if deal_from_date.present? && deal_to_date.present?
				errors.add(:deal_to_date, :cannot_be_in_the_past_msg) unless deal_to_date > Time.now
				errors.add(:deal_to_date, :cannot_happen_before_from_date_msg) unless deal_to_date > deal_from_date
			end
		end

		def deal_price_cannot_blank
			if is_deal == true
				errors.add(:deal_price, :cannot_blank_msg) unless !deal_price.nil?
				errors.add(:deal_percent, :cannot_blank_msg) unless !deal_percent.nil?
			end
		end
	
		def check_for_duplicate_alias
			Erp::Products::Product.where.not(id: self.id).where(alias: self.alias).pluck(:id)
		end

    #START ARCHIVE
    def self.archive
			update_all(archived: true)
		end
    def self.unarchive
			update_all(archived: false)
		end
		#END ARCHIVE

		#START BESTSELLER
    def self.check_is_bestseller
			update_all(is_bestseller: true)
		end
    def self.uncheck_is_bestseller
			update_all(is_bestseller: false)
		end
		#END BESTSELLER

		#START CALL
    def self.check_is_call
			update_all(is_call: true)
		end
    def self.uncheck_is_call
			update_all(is_call: false)
		end
		#END CALL

		#START SOLD OUT
    def self.check_is_sold_out
			update_all(is_sold_out: true)
		end
    def self.uncheck_is_sold_out
			update_all(is_sold_out: false)
		end
		#END SOLD OUT

		#START HK-ERP CONNECTOR
		has_one :hkerp_product, dependent: :destroy

		def updateHkerpInfo(pid)
			url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_get_info?id=' + pid.to_s
			uri = URI(url)
			begin
				res = Net::HTTP.get_response(uri)
			rescue
			end
			if res.is_a?(Net::HTTPSuccess)
				data = JSON.parse(res.body)
				if self.hkerp_product.nil?
					self.hkerp_product = Erp::Products::HkerpProduct.new(hkerp_product_id: data['id'], price: data['price'], stock: data['stock'], data: res.body)
				else
					self.hkerp_product.update_attributes(hkerp_product_id: data['id'], price: data['price'], stock: data['stock'], data: res.body)
				end
				self.price = data['price']
				self.listed_price = data['listed_price']
				self.warranty = data['warranty']
				self.name = data['name'] if !self.name.present?
				self.short_name = data['fixed_name'] if !self.short_name.present?
				self.code = data['product_code'] if !self.code.present?
			end
		end

		def getHkerpInfo
			return {} if !hkerp_product.present?
			pid = self.hkerp_product.hkerp_product_id
			url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_get_info?id=' + pid.to_s
			uri = URI(url)
			begin
				res = Net::HTTP.get_response(uri)
			rescue
			end
			if res.is_a?(Net::HTTPSuccess)
				data = JSON.parse(res.body)
				return data
			else
				return {}
			end
		end

		after_save :hkerp_set_imported
		after_save :hkerp_set_sold_out
		before_destroy :hkerp_set_not_imported
		after_save :hkerp_update_price
		#after_save :hkerp_set_cache_thcn_url
		#after_save :hkerp_set_cache_thcn_properties
		after_save :destroy_all_product_images_nil

		def destroy_all_product_images_nil
			self.product_images.where(image_url: nil).destroy_all
		end
		
		def hkerp_set_imported
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_imported'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id)
			end
		end

		def hkerp_update_imported
			url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_imported'
			uri = URI(url)
			Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id, 'value' => self.hkerp_product.present?.to_s)
		end

		def hkerp_set_not_imported
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_imported'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id, 'value' => 'false')
			end
		end

		def hkerp_set_sold_out
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_sold_out'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id, 'value' => self.is_sold_out)
			end
		end

		def hkerp_update_price(force=false)
			if self.hkerp_product.present?
				if force
					self.update_column(:price, self.hkerp_product.price)
				end
				if self.price.to_f == self.hkerp_product.get_data['price'].to_f
					url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_price_update'
					uri = URI(url)
					Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id)
				end
			end
		end

		def update_products_values
			if self.product_property_values.present?
				properties_value_ids = []
				self.product_property_values.each do |row|
					row = row[1]
					properties_value_ids += row['ids'].select {|id| id.to_i > 0} if row['ids'].present?
					if row['names'].present?
						row['names'].each do |name|
							name = name.strip
							if name.present?
								properties_value = PropertiesValue.create_if_not_exists(row['property_id'].to_i, name)
								properties_value_ids << properties_value.id
							end
						end
					end
				end
				self.products_values.destroy_all
				properties_value_ids.each do |prv_id|
					self.products_values.create(properties_value_id: prv_id)
				end
			end
		end

		def hkerp_set_cache_thcn_url
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_cache_thcn_url'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id, 'url' => "https://timhangcongnghe.com/#{self.alias}-pid#{self.id}")
			end
		end

		def hkerp_set_cache_thcn_properties
			result = {short: nil, long: []}
			self.product_values_array.each do |group|
				if group[:group].show_name.present?
					result[:long] << {group: group[:group].get_show_name, properties: group[:properties]}
				else
					result[:long] << {group: group[:group].get_name, properties: group[:properties]}
				end
			end
			result[:short] = self.product_short_descipriton_values_array
			data = result.to_json
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_cache_thcn_properties'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id, 'data' => data)
			end
		end

		def product_values_array
			groups = []
			self.category.property_groups.where(is_filter_specs: false).each do |group|
				row = {}
				row[:group] = group
				row[:properties] = []
				group.properties.each do |property|
					row2 = {}
					row2[:property] = property
					row2[:values] = self.products_values_by_property(property).map {|pv| pv.properties_value.get_value }
					row[:properties] << row2 if !row2[:values].empty?
				end
				groups << row if !row[:properties].empty?
			end
			return groups
		end

		def product_short_descipriton_values_array
			groups = []
			return [] if self.category.nil?
			self.category.property_groups.where(is_filter_specs: false).each do |group|
				row = {}
				if group.show_name.present?
					row[:name] = group.get_show_name
				else
					row[:name] = group.get_name
				end
				row[:values] = []
				group.properties.where(is_show_detail: true).each do |property|
					values = self.products_values_by_property(property).map {|pv| pv.properties_value.get_value}
					row[:values] += values if !values.empty?
				end
				groups << row if !row[:values].empty?
			end
			return groups
		end
		
		def product_short_descipriton_values_array_new_specs
			groups = []
			return [] if self.category.nil? || self.category.property_groups.count == 0
			property_group = self.category.property_groups.first
			property_group.properties.where(is_show_detail: true).each do |property|
				row = {}
				row[:name] = property.get_name
				row[:values] = []
				values = self.products_values_by_property(property).map {|pv| pv.properties_value.get_value}
				row[:values] += values if !values.empty?
				groups << row if !row[:values].empty?
			end
			return groups
		end

		def self.check_hkerp_product_imported(pid)
			if Erp::Products::HkerpProduct.where(hkerp_product_id: pid).empty?
				url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_set_imported'
				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => pid, 'value' => 'false')
			end
		end
		#END HK-ERP CONNECTOR

		has_many :cart_items, class_name: 'Erp::Carts::CartItem'
		before_destroy :ensure_not_referenced_by_any_cart_item
		
		private
			def ensure_not_referenced_by_any_cart_item
				if cart_items.empty?
					return true
				else
					errors.add(:base, 'Sản phẩm trong giỏ hàng đang tồn tại!')
					return false
				end
			end

		after_create :create_alias
		after_save :update_cache_search
		after_save :update_cache_properties
		#after_save :save_short_description
		after_save :save_meta_description

		def create_alias
			if self.custom_alias.present?
				name = self.get_custom_alias
			else
				name = self.get_short_name
			end
			self.update_column(:alias, name.to_ascii.downcase.to_s.gsub(/[^0-9a-z \/\-\.]/i, '').gsub(/[ \/\.]+/i, '-').strip)
		end

		def update_cache_search
			str = []
			str << get_name.to_s.downcase.strip
			str << get_category_name.to_s.downcase.strip
			self.update_column(:cache_search, str.join(' ') + ' ' + str.join(' ').to_ascii)
		end

		def update_cache_properties
			arr = {}
			products_values.each do |pv|
				arr[pv.properties_value.property_id] = [pv.properties_value_id.to_s, pv.properties_value.value]
			end
			update_column(:cache_properties, arr.to_json)
			cache_properties = arr.to_json
		end

		def save_short_description
			str = get_short_description
			update_columns(short_description: str)
		end

		def get_short_description
			data = []
			category.property_groups.each do |group|
				group.properties.where(is_short_description: true).each do |property|
					values = products_values_by_property(property).map {|pv| pv.properties_value.value }
					data += values if !values.empty?
				end
			end
			return data.join(' - ')
		end

		def save_meta_description
			str = get_meta_description
			update_columns(meta_description: str)
		end

		def get_meta_description
			data = []
			if category.short_meta_description.present?
				 data << category.short_meta_description
			end
			if brand.present?
				 data << brand.get_name
			end
			category.property_groups.each do |group|
				group.properties.where(is_meta_description: true).each do |property|
					values = products_values_by_property(property).map {|pv| pv.properties_value.value}
					data += values if !values.empty?
				end
			end
			return data.join(' ')
		end
  end
end