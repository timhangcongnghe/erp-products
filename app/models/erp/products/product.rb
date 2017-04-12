module Erp::Products
  class Product < ApplicationRecord
		attr_accessor :products_values_attributes
		validates :name, :uniqueness => true

    validates :name, :category_id, :brand_id, :presence => true

    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category
    belongs_to :brand
    belongs_to :accessory
    belongs_to :unit, class_name: 'Erp::Products::Unit', optional: true

    has_many :comments, class_name: "Erp::Products::Comment"
    has_many :ratings, class_name: "Erp::Products::Rating"

    if Erp::Core.available?("taxes")
      has_and_belongs_to_many :customer_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_customer_taxes'
			has_and_belongs_to_many :vendor_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_vendor_taxes'
    end

    has_many :products_properties, dependent: :destroy
    has_and_belongs_to_many :properties, class_name: 'Erp::Products::Property', :join_table => 'erp_products_products_properties'

    has_many :products_units, dependent: :destroy
    accepts_nested_attributes_for :products_units, :reject_if => lambda { |a| a[:unit_id].blank? or a[:conversion_value].blank? }, :allow_destroy => true

    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image_url].blank? and a[:image_url_cache].blank? }, :allow_destroy => true

    has_many :products_parts, dependent: :destroy
    accepts_nested_attributes_for :products_parts, :reject_if => lambda { |a| a[:part_id].blank? }, :allow_destroy => true

    has_many :products_values, through: :products_properties, dependent: :destroy
    has_many :comments, class_name: 'Erp::Products::Comment', dependent: :destroy
    has_many :ratings, class_name: 'Erp::Products::Rating', dependent: :destroy

    if Erp::Core.available?("carts")
			has_many :cart_items, class_name: 'Erp::Carts::CartItem'
			before_destroy :ensure_not_referenced_by_any_cart_item
		end

    after_initialize :set_attr

    OUT_OF_STOCK = 'out_of_stock'
    IN_TOCK = 'in_stock'

    def self.get_active
			self.where(archived: false).order("created_at DESC")
		end

		def set_attr
			@products_values_attributes = []
			if !self.properties.empty?
				self.properties.each do |property|
					@products_values_attributes << {1 => {
							:property_id => property.id,
							:ids => self.values_by_property(property).map {|pv| pv.properties_value_id},
							:names => []
					}}
				end
			end
		end

		def values_by_property(property)
			self.products_properties.where(property_id: property.id).first.products_values #values.joins(:products_property).where(erp_products_products_properties: {property_id: property.id})
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

      # join with categories table for search with category
      query = query.joins(:category)

      # showing archived items if show_archived is not true
			query = query.where(archived: false) if show_archived == false

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      # single keyword
      if params[:keyword].present?
				keyword = params[:keyword].strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(erp_products_products.name) LIKE ?', '%'+q+'%')
				end
			end

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

      query = query.limit(8).map{|product| {value: product.id, text: product.name} }
    end

    # set archived
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

    # set is best seller
    def check_is_bestseller
			update_columns(is_bestseller: true)
		end

    def uncheck_is_bestseller
			update_columns(is_bestseller: false)
		end

    def self.check_is_bestseller_all
			update_all(is_bestseller: true)
		end

    def self.uncheck_is_bestseller_all
			update_all(is_bestseller: false)
		end

    # category name
    def category_name
			category.present? ? category.name : ''
		end

    # unit name
    def unit_name
			unit.present? ? unit.name : ''
		end

    # brand name
    def brand_name
			brand.present? ? brand.name : ''
		end

    # accessory name
    def accessory_name
			accessory.present? ? accessory.name : ''
		end

    # color name
    def color_name
			brand.present? ? brand.name : ''
		end

    # remain stock
    def stock
			result = Erp::Deliveries::DeliveryDetail.joins(:delivery).joins(:order_detail)
			.where(erp_deliveries_deliveries: {delivery_type: Erp::Deliveries::Delivery::TYPE_IMPORT})
			.where(erp_orders_order_details: {product_id: self.id})
			.sum("erp_deliveries_delivery_details.quantity") - Erp::Deliveries::DeliveryDetail.joins(:delivery).joins(:order_detail)
			.where(erp_deliveries_deliveries: {delivery_type: Erp::Deliveries::Delivery::TYPE_EXPORT})
			.where(erp_orders_order_details: {product_id: self.id})
			.sum("erp_deliveries_delivery_details.quantity")
			return result
		end

    # stock status
    def stock_status
			if stock <= 0
				return OUT_OF_STOCK
			else
				return IN_TOCK
			end
		end

    # safe properties values from hash
    def update_products_values
			if self.products_values_attributes.present?
				products_value_ids = []

				# save new properties values
				self.products_values_attributes.each do |pv|
					pv = pv[1]

					# Collect all exist and new product values properties
					properties_value_ids = []

					# exist products values properties
					properties_value_ids = pv['ids'].select {|id| id.to_i > 0} if pv['ids'].present?

					# create if not exist
					if pv['names'].present?
						pv['names'].each do |name|
							name = name.strip
							if name.present?
								properties_value = PropertiesValue.create_if_not_exists(pv['property_id'], name)
								properties_value_ids << properties_value.id
							end
						end
					end

					# add values to product properties
					properties_value_ids.each do |pv_id|
						property = Property.find(pv['property_id'])
						self.properties << property if !self.properties.include?(property)
						products_property = self.products_properties.where(property_id: property.id).first
						products_value = ProductsValue.create_if_not_exists(properties_value_id: pv_id, products_property_id: products_property.id)

						# stack product value ids
						products_value_ids << products_value.id
					end
				end

				# Delete products values if not exist
				self.products_values.where.not(id: products_value_ids).destroy_all

				# Delete products properties not have value
				self.products_properties.each do |pp|
					pp.destroy if self.products_values.where(products_property_id: pp.id).empty?
				end
			end
    end

    # get product main images
    def main_image
			product_images.first
		end

    # get product sub images
    def sub_images
			product_images.second
		end

    def self.get_business_choices
			self.get_active.where(is_business_choices: true)
		end

    def self.get_top_business_choices
			self.get_business_choices.where(is_top_business_choices: true)
		end

    def self.get_deal_products
			self.get_active.where(is_deal: true)
		end

    def self.limit_deal_products
			self.get_deal_products.limit(15)
		end

    def self.get_bestseller_products
			self.get_active.where(is_bestseller: true)
		end

    def product_price
			# product is not deal
			return self.price if !self.is_deal
			# product is deal
			from_conds = !self.deal_from_date.present? || (self.deal_from_date.present? && Time.now >= self.deal_from_date.beginning_of_day)
			to_conds = !self.deal_to_date.present? || (self.deal_to_date.present? && Time.now >= self.deal_to_date.end_of_day)
			if from_conds && to_conds
				return self.deal_price
			else
				return self.price
			end
		end

    # get product properties array
    def get_product_property_array
			arr = []
			self.products_properties.each do |product_property|
				row = {
					name: product_property.property.name,
					values: product_property.products_values.map {|products_value|
						products_value.properties_value.value
					}
				}
				arr << row
			end
			arr
		end

    # count stars
		def count_stars
			self.ratings.map(&:star)
		end

		# average stars
		def average_stars
			# calculate average stars
			count_stars.empty? ? 0 : count_stars.inject(0, :+) / count_stars.length
		end

		def self.get_deal_products
			self.get_active.where(is_deal: true)
		end

		def self.get_bestseller_products
			self.get_active.where(is_bestseller: true)
		end

		# If menus engines available
    if Erp::Core.available?("menus")
			# Find all menus of a product
			def find_menus
				self.category.nil? ? nil : self.category.menus
			end

			def find_menu
				self.find_menus.last
			end
		end

    #@todo HK-ERP connector
    has_one :hkerp_product, dependent: :destroy

    def updateHkerpInfo(pid)
			url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_get_info?id=" + pid.to_s
			uri = URI(url)
			res = Net::HTTP.get_response(uri)

			if res.is_a?(Net::HTTPSuccess)
				data = JSON.parse(res.body)

				if self.hkerp_product.nil?
					self.hkerp_product = Erp::Products::HkerpProduct.new(
						hkerp_product_id: data["id"],
						price: data["price"],
						stock: data["stock"],
						data: res.body
					)
				else
					self.hkerp_product.update_attributes(
						hkerp_product_id: data["id"],
						price: data["price"],
						stock: data["stock"],
						data: res.body
					)
				end

				self.price = data["price"]
				self.name = data["name"] if !self.name.present?
				self.code = data["product_code"] if !self.code.present?
			end
		end

		after_create :hkerp_set_imported
		after_save :hkerp_update_price

    def hkerp_update_price(force=false)
			if self.hkerp_product.present?
				if force
					self.update_column(:price, self.hkerp_product.price)
				end
				if self.price.to_f == self.hkerp_product.get_data["price"].to_f
					url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_price_update"

					uri = URI(url)
					Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id)
				end
			end
		end

		def hkerp_set_imported
			if self.hkerp_product.present?
				url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_set_imported"

				uri = URI(url)
				Net::HTTP.post_form(uri, 'id' => self.hkerp_product.hkerp_product_id)

				self.product_images.where(image_url: nil).destroy_all
			end
		end
		##########################

    private
    if Erp::Core.available?("carts")
			# ensure that there are no cart items referencing this product
			def ensure_not_referenced_by_any_cart_item
				if cart_items.empty?
					return true
				else
					errors.add(:base, "Cart Items present")
					return false
				end
			end
		end
  end
end
