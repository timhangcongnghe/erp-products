module Erp::Products
  class Category < ApplicationRecord
		include Erp::CustomOrder

		validates :name, :presence => true

		has_many :products
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :parent, class_name: "Erp::Products::Category", optional: true
    has_many :children, class_name: "Erp::Products::Category", foreign_key: "parent_id"
    if Erp::Core.available?("menus")
			has_and_belongs_to_many :menus, class_name: "Erp::Menus::Menu"
		end
    has_and_belongs_to_many :property_groups, -> { order 'erp_products_property_groups.custom_order' }, class_name: "Erp::Products::PropertyGroup", :join_table => 'erp_products_categories_pgroups'

    after_save :update_level

    # Get product properties for list
		def category_get_properties_array
			groups = []
      return [] if self.nil?
			self.property_groups.get_active.each do |group|
				row = {}
				row[:name] = group.name
				row[:values] = []
				group.properties.get_properties_for_filter.each do |property|
					values = property.properties_values.get_property_values_for_filter.map {|pv| pv }
					row[:values] += values if !values.empty?
				end
				groups << row if !row[:values].empty?
			end

			return groups
		end

    # get self and children ids
    def get_self_and_children_ids
      ids = [self.id]
      ids += get_children_ids_recursive
      return ids
		end

    # get children ids recursive
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

    # update level
    def update_level
			level = 1
			parent = self.parent
			while parent.present?
				level += 1
				parent = parent.parent
			end

			level
		end

    # init custom order
    def init_custom_order
			self.update_column(:custom_order, self.class.maximum("custom_order").to_i + 1)
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
      query = query.joins("LEFT JOIN erp_products_categories parents_erp_products_categories ON parents_erp_products_categories.id = erp_products_categories.parent_id")

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
    def self.dataselect(keyword='', params={})
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      if params[:current_value].present?
        query = query.where.not(id: params[:current_value].split(','))
      end

      query = query.limit(20).map{|category| {value: category.id, text: (category.parent_name.empty? ? '' : "#{category.parent_name} / ") + category.name} }
    end

    # product count
    def product_count
			products.count
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

    # display name
    def parent_name
			parent.present? ? parent.name : ''
		end

		# display name with parent
    def full_name
			names = [self.name]
			p = self.parent
			while !p.nil? do
				names << p.name
				p = p.parent
			end
			names.reverse.join(" >> ")
		end

    # Get get all archive
    def self.all_unarchive
			self.where(archived: false)
		end

    # --------- Report Functions - Start ---------
    # Get sales order details
    def self.get_sales_order_details(params={})
      query = Erp::Orders::OrderDetail.joins(:order, :product)
        .where(erp_orders_orders: {status: Erp::Orders::Order::STATUS_CONFIRMED})
        .where(erp_orders_orders: {supplier_id: Erp::Contacts::Contact.get_main_contact.id})

      if params[:from_date].present?
				query = query.where('erp_orders_orders.order_date >= ?', params[:from_date].to_date.beginning_of_day)
			end

			if params[:to_date].present?
				query = query.where('erp_orders_orders.order_date <= ?', params[:to_date].to_date.end_of_day)
			end

			if Erp::Core.available?("periods")
				if params[:period].present?
					query = query.where('erp_orders_orders.order_date >= ? AND erp_orders_orders.order_date <= ?',
            Erp::Periods::Period.find(params[:period]).from_date.beginning_of_day,
            Erp::Periods::Period.find(params[:period]).to_date.end_of_day)
				end
			end

			return query
    end

    def get_sales_order_details(params={})
      query = Category.get_sales_order_details(params).where(erp_products_products: {category_id: self.id})
    end

    # Get sales count
    def get_sales_count(params={})
      self.get_sales_order_details(params).count
    end

    # Get sales amount
    def get_sales_amount(params={})
      self.get_sales_order_details(params).sum(:cache_real_revenue)
    end

    # Get sales quantity
    def get_sales_quantity(params={})
      self.get_sales_order_details(params).sum(:quantity)
    end

    # Total sales amount
    def self.total_sales_amount(params={})
      self.get_sales_order_details(params).sum(:cache_real_revenue)
    end

    # Total sales quantity
    def self.total_sales_quantity(params={})
      self.get_sales_order_details(params).sum(:quantity)
    end

    # Get return delivery details (customer import) - Co chung tu
    def self.get_return_delivery_details(params={})
      query = Erp::Qdeliveries::DeliveryDetail.joins(:delivery, :order_detail => :product)
        .where.not(order_detail_id: nil)
        .where(erp_qdeliveries_deliveries: {status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED})
        .where(erp_qdeliveries_deliveries: {delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOMER_IMPORT})
        #.where(erp_products_products: {category_id: self.id})

      if params[:from_date].present?
				query = query.where('erp_qdeliveries_deliveries.date >= ?', params[:from_date].to_date.beginning_of_day)
			end

			if params[:to_date].present?
				query = query.where('erp_qdeliveries_deliveries.date <= ?', params[:to_date].to_date.end_of_day)
			end

			if Erp::Core.available?("periods")
				if params[:period].present?
					query = query.where('erp_qdeliveries_deliveries.date >= ? AND erp_qdeliveries_deliveries.date <=',
            Erp::Periods::Period.find(params[:period]).from_date.beginning_of_day,
            Erp::Periods::Period.find(params[:period]).to_date.end_of_day)
				end
			end

			return query
    end

    def get_return_delivery_details(params={})
      query = Category.get_return_delivery_details(params).where(erp_products_products: {category_id: self.id})
    end

    # Get return delivery details (customer import) - Khong chung tu
    def self.get_return_delivery_details_without_order(params={})
      query = Erp::Qdeliveries::DeliveryDetail.joins(:delivery, :product)
        .where(order_detail_id: nil)
        .where(erp_qdeliveries_deliveries: {status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED})
        .where(erp_qdeliveries_deliveries: {delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOMER_IMPORT})

      if params[:from_date].present?
				query = query.where('erp_qdeliveries_deliveries.date >= ?', params[:from_date].to_date.beginning_of_day)
			end

			if params[:to_date].present?
				query = query.where('erp_qdeliveries_deliveries.date <= ?', params[:to_date].to_date.end_of_day)
			end

			if Erp::Core.available?("periods")
				if params[:period].present?
					query = query.where('erp_qdeliveries_deliveries.date >= ? AND erp_qdeliveries_deliveries.date <=',
            Erp::Periods::Period.find(params[:period]).from_date.beginning_of_day,
            Erp::Periods::Period.find(params[:period]).to_date.end_of_day)
				end
			end

			return query
    end

    def get_return_delivery_details_without_order(params={})
      query = Category.get_return_delivery_details_without_order(params).where(erp_products_products: {category_id: self.id})
    end

    # Return count
    def get_return_count(params={})
      self.get_return_delivery_details(params).count + self.get_return_delivery_details_without_order(params).count
    end

    # Get return amount
    def get_return_amount(params={})
      self.get_return_delivery_details(params).sum(:cache_total) + self.get_return_delivery_details_without_order(params).sum(:cache_total)
    end

    # Get return quantity
    def get_return_quantity(params={})
      self.get_return_delivery_details(params).sum(:quantity) + self.get_return_delivery_details_without_order(params).sum(:quantity)
    end

    # Total sales amount
    def self.total_return_amount(params={})
      self.get_return_delivery_details(params).sum(:cache_total) + self.get_return_delivery_details_without_order(params).sum(:cache_total)
    end

    # Total sales quantity
    def self.total_return_quantity(params={})
      self.get_return_delivery_details(params).sum(:quantity) + self.get_return_delivery_details_without_order(params).sum(:quantity)
    end

    # Total sales without return
    def self.total_sales_quantity_without_return(params={})
      self.total_sales_quantity(params) - self.total_return_quantity(params)
    end

    def self.total_sales_amount_without_return(params={})
      self.total_sales_amount(params) - self.total_return_amount(params)
    end
    # --------- Report Functions - End ---------

  end
end
