module Erp::Products
  class Product < ApplicationRecord
		attr_accessor :products_values_attributes
		
    validates :name, :category_id, :presence => true
    
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category
    belongs_to :unit, class_name: 'Erp::Products::Unit', optional: true
    
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
    
    has_many :products_values, through: :products_properties
    
    after_initialize :set_attr
    
    OUT_OF_STOCK = 'out_of_stock'
    IN_TOCK = 'in_stock'

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
    
    # category name
    def category_name
			category.present? ? category.name : ''
		end
    
    # unit name
    def unit_name
			unit.present? ? unit.name : ''
		end
    
    # remain stock
    def stock
			result = Erp::Deliveries::DeliveryDetail.joins(:delivery).joins(:order_detail)
			.where(erp_deliveries_deliveries: {delivery_type: Erp::Deliveries::Delivery::TYPE_IMPORT})
			.where(erp_sales_order_details: {product_id: self.id})
			.sum("erp_deliveries_delivery_details.quantity") - Erp::Deliveries::DeliveryDetail.joins(:delivery).joins(:order_detail)
			.where(erp_deliveries_deliveries: {delivery_type: Erp::Deliveries::Delivery::TYPE_EXPORT})
			.where(erp_sales_order_details: {product_id: self.id})
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
				# save new properties values
				self.products_values_attributes.each do |pv|
					pv = pv[1]
					properties_value_ids = pv['ids'].select {|id| id.to_i > 0} if pv['ids'].present?
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
						products_value = ProductsValue.create(properties_value_id: pv_id, products_property_id: products_property.id)
					end
				end
			end
    end
    
    # get products values names array
  end
end
