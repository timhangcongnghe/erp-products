module Erp::Products
  class Product < ApplicationRecord
		attr_accessor :product_property_values
		#validates :name, :uniqueness => true
    validates :category_id, :presence => true
    validate :deal_to_date_cannot_be_in_the_past, :deal_price_cannot_blank

    belongs_to :creator, class_name: "Erp::User"
    belongs_to :category
    belongs_to :brand, optional: true
    belongs_to :accessory, optional: true
    belongs_to :unit, class_name: 'Erp::Products::Unit', optional: true

    has_many :comments, class_name: "Erp::Products::Comment"
    has_many :ratings, class_name: "Erp::Products::Rating"

    has_many :cache_stocks, class_name: "Erp::Products::CacheStock"

		if Erp::Core.available?("orders")
			has_many :order_details, class_name: "Erp::Orders::OrderDetail"
		end

    after_save :update_cache_properties
    if Erp::Core.available?("warehouses")
      after_save :update_cache_stock

      # update cache stock
      def update_cache_stock
        self.update_column(:cache_stock, self.get_stock)

        Erp::Products::CacheStock.update_stock(self, self.get_stock)

        # update cache stock for state warehouse
        Erp::Products::State.all.each do |state|
          Erp::Products::CacheStock.update_stock(self, self.get_stock(state: state), {state_id: state.id})
          Erp::Warehouses::Warehouse.all.each do |warehouse|
            Erp::Products::CacheStock.update_stock(self, self.get_stock(warehouse: warehouse, state: state), {warehouse_id: warehouse.id, state_id: state.id})
          end
        end
        Erp::Warehouses::Warehouse.all.each do |warehouse|
          Erp::Products::CacheStock.update_stock(self, self.get_stock(warehouse: warehouse), {warehouse_id: warehouse.id})
        end
      end
    end

    if Erp::Core.available?("taxes")
      has_and_belongs_to_many :customer_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_customer_taxes'
			has_and_belongs_to_many :vendor_taxes, class_name: 'Erp::Taxes::Tax', :join_table => 'erp_products_vendor_taxes'
    end

    has_many :products_units, dependent: :destroy
    accepts_nested_attributes_for :products_units, :reject_if => lambda { |a| a[:unit_id].blank? or a[:conversion_value].blank? }, :allow_destroy => true

    has_many :product_images, dependent: :destroy
    accepts_nested_attributes_for :product_images, :reject_if => lambda { |a| a[:image_url].blank? and a[:image_url_cache].blank? }, :allow_destroy => true

    has_many :products_parts, dependent: :destroy
    accepts_nested_attributes_for :products_parts, :reject_if => lambda { |a| a[:part_id].blank? }, :allow_destroy => true

    has_many :products_gifts, dependent: :destroy
    accepts_nested_attributes_for :products_gifts, :reject_if => lambda { |a| a[:gift_id].blank? }, :allow_destroy => true

    has_many :gifts, through: :products_gifts, class_name: 'Erp::Products::Product', foreign_key: :gift_id

    has_and_belongs_to_many :events, class_name: 'Erp::Products::Event', :join_table => 'erp_products_events_products'

    has_many :products_values, -> { order 'erp_products_products_values.id' }, dependent: :destroy
    has_many :comments, class_name: 'Erp::Products::Comment', dependent: :destroy
    has_many :ratings, class_name: 'Erp::Products::Rating', dependent: :destroy

    OUT_OF_STOCK = 'out_of_stock'
    IN_TOCK = 'in_stock'

    def price=(new_price)
      self[:price] = new_price.to_s.gsub(/\,/, '')
    end
    def deal_price=(new_price)
      self[:deal_price] = new_price.to_s.gsub(/\,/, '')
    end

    if Erp::Core.available?("qdeliveries")
      has_many :delivery_details, class_name: 'Erp::Qdeliveries::DeliveryDetail', dependent: :destroy

      # Get all delivered delivery details
      def delivered_delivery_details
        delivery_details.joins(:delivery).
          where(erp_qdeliveries_deliveries: {
            status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED
          }
        )
      end

			ImportArrays = [
        Erp::Qdeliveries::Delivery::TYPE_PURCHASE_IMPORT,
        Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT,
        Erp::Qdeliveries::Delivery::TYPE_CUSTOM_IMPORT,
      ]
			ExportArrays = [
        Erp::Qdeliveries::Delivery::TYPE_PURCHASE_EXPORT,
        Erp::Qdeliveries::Delivery::TYPE_SALES_EXPORT,
        Erp::Qdeliveries::Delivery::TYPE_CUSTOM_EXPORT,
      ]

			def self.get_delivery_query(params={})
        query = Erp::Qdeliveries::DeliveryDetail.joins(:delivery)
          .where(erp_qdeliveries_deliveries: {
            status: Erp::Qdeliveries::Delivery::STATUS_DELIVERED,
          })

        # from date
        query = query.where("erp_qdeliveries_deliveries.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_qdeliveries_deliveries.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# warehouse
				query = query.where(warehouse_id: params[:warehouse].id) if params[:warehouse].present?
				# state
				query = query.where(state_id: params[:state].id) if params[:state].present?
				# warehouse ids
				query = query.where(warehouse_id: params[:warehouse_ids]) if params[:warehouse_ids].present?
				# state ids
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				# delivery type
				query = query.where(erp_qdeliveries_deliveries: {delivery_type: params[:delivery_type]}) if params[:delivery_type].present?

				return query
      end

			# @todo import
			def self.get_qdelivery_import(params={})
				stock = 0

				main_query = self.get_delivery_query(params).where(erp_qdeliveries_deliveries: {
          delivery_type: Erp::Products::Product::ImportArrays,
        })

				# qdelivery detail with order detail
				query = main_query.joins(:order_detail)
					.where.not(order_detail_id: nil)

				if params[:product_id].present?
					query = query.where(erp_orders_order_details: {product_id: params[:product_id]})
				end

				if params[:customer_id].present?
					query = query.where(erp_qdeliveries_deliveries: {customer_id: params[:customer_id]})
				end

				stock = stock + query.sum("erp_qdeliveries_delivery_details.quantity")

				# qdelivery detail without order detail
				query = main_query.where(order_detail_id: nil)

				if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

				if params[:customer_id].present?
					query = query.where(erp_qdeliveries_deliveries: {customer_id: params[:customer_id]})
				end

				stock = stock + query.sum("erp_qdeliveries_delivery_details.quantity")

				return stock
			end

			# @todo export
			def self.get_qdelivery_export(params={})
        stock = 0

				main_query = self.get_delivery_query(params).where(erp_qdeliveries_deliveries: {
          delivery_type: Erp::Products::Product::ExportArrays,
        })

				# qdelivery detail with order detail
				query = main_query.joins(:order_detail)
					.where.not(order_detail_id: nil)

				if params[:product_id].present?
					query = query.where(erp_orders_order_details: {product_id: params[:product_id]})
				end

				stock = stock + query.sum("erp_qdeliveries_delivery_details.quantity")

				# qdelivery detail without order detail
				query = main_query.where(order_detail_id: nil)

				if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

				stock = stock + query.sum("erp_qdeliveries_delivery_details.quantity")

				return stock
			end
		end

    if Erp::Core.available?("stock_transfers")
			def self.get_transfer_query(params={})
        query = Erp::StockTransfers::TransferDetail.joins(:transfer)
          .where(erp_stock_transfers_transfers: {
            status: Erp::StockTransfers::Transfer::STATUS_DELIVERED,
          })

        # product
        if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

        # from date
        query = query.where("erp_stock_transfers_transfers.received_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_stock_transfers_transfers.received_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# state ids
				query = query.where(state_id: params[:state].id) if params[:state].present?
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				return query
      end

			# @todo import
			def self.get_transfer_import(params={})
				stock = 0

				if params[:warehouse_ids].present?
          query = self.get_transfer_query(params).where(erp_stock_transfers_transfers: {destination_warehouse_id: params[:warehouse_ids]})
          stock = stock + query.sum("erp_stock_transfers_transfer_details.quantity")
        end

				return stock
			end

      def self.get_transfer_export(params={})
				stock = 0

				if params[:warehouse_ids].present?
          query = self.get_transfer_query(params).where(erp_stock_transfers_transfers: {source_warehouse_id: params[:warehouse_ids]})
          stock = stock + query.sum("erp_stock_transfers_transfer_details.quantity")
        end

				return stock
			end
		end

    #if Erp::Core.available?("stock_transfers")
			def self.get_stock_check_query(params={})
        query = Erp::Products::StockCheckDetail.joins(:stock_check)
          .where(erp_products_stock_checks: {
            status: Erp::Products::StockCheck::STATUS_DONE,
          })

        # product
        if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

        # from date
        query = query.where("erp_products_stock_checks.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_products_stock_checks.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# state ids
				query = query.where(state_id: params[:state].id) if params[:state].present?
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				# warehouse id
				query = query.where(erp_products_stock_checks: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				query = query.where(erp_products_stock_checks: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?

				return query
      end

			# @todo import
			def self.get_stock_check_import(params={})
				stock = 0

				query = self.get_stock_check_query(params)
				query = query.where("erp_products_stock_check_details.quantity > ?", 0)
				stock = stock + query.sum("erp_products_stock_check_details.quantity")

				return stock
			end

      # @todo import
			def self.get_stock_check_export(params={})
				stock = 0

				query = self.get_stock_check_query(params)
				query = query.where("erp_products_stock_check_details.quantity < ?", 0)
				stock = stock - query.sum("erp_products_stock_check_details.quantity")

				return stock
			end
		#end

		# STATE CHECKS if Erp::Core.available?("stock_transfers")
			def self.get_state_check_query(params={})
        query = Erp::Products::StateCheckDetail.joins(:state_check)
          .where(erp_products_state_checks: {
            status: Erp::Products::StateCheck::STATE_CHECK_STATUS_ACTIVE,
          })

        # product
        if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

        # from date
        query = query.where("erp_products_state_checks.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_products_state_checks.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# state ids
				query = query.where(state_id: params[:state].id) if params[:state].present?
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				# warehouse id
				query = query.where(erp_products_stock_checks: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				query = query.where(erp_products_stock_checks: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?

				return query
      end

			# @todo import
			def self.get_state_check_import(params={})
				stock = 0

				query = self.get_state_check_query(params)
				query = query.where(state_id: params[:state_id])
				stock = stock + query.sum("erp_products_state_check_details.quantity")

				return stock
			end

      # @todo import
			def self.get_state_check_export(params={})
				stock = 0

				query = self.get_state_check_query(params)
				query = query.where(old_state_id: params[:state_id])
				stock = stock - query.sum("erp_products_state_check_details.quantity")

				return stock
			end
		#end

		if Erp::Core.available?("gift_givens")
			def self.get_gift_given_query(params={})
        query = Erp::GiftGivens::GivenDetail.joins(:given)
          .where(erp_gift_givens_givens: {
            status: Erp::GiftGivens::Given::STATUS_DELIVERED,
          })

        # product
        if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

        # from date
        query = query.where("erp_gift_givens_givens.given_date >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_gift_givens_givens.given_date <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# state ids
				query = query.where(state_id: params[:state].id) if params[:state].present?
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				# warehouse id
				query = query.where(warehouse_id: params[:warehouse].id) if params[:warehouse].present?
				query = query.where(warehouse_id: params[:warehouse_ids]) if params[:warehouse_ids].present?

				return query
      end

      # @todo import
			def self.get_gift_given_export(params={})
				stock = 0

				query = self.get_gift_given_query(params)
				stock = stock + query.sum("erp_gift_givens_given_details.quantity")

				return stock
			end
		end

		#if Erp::Core.available?("gift_givens")
			def self.get_damage_record_query(params={})
        query = Erp::Products::DamageRecordDetail.joins(:damage_record)
          .where(erp_products_damage_records: {
            status: Erp::Products::DamageRecord::STATUS_DONE,
          })

        # product
        if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

        # from date
        query = query.where("erp_products_damage_records.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_products_damage_records.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# state ids
				query = query.where(state_id: params[:state].id) if params[:state].present?
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				# warehouse id
				query = query.where(erp_products_damage_records: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				query = query.where(erp_products_damage_records: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?

				return query
      end

      # @todo import
			def self.get_damage_record_export(params={})
				stock = 0

				query = self.get_damage_record_query(params)
				stock = stock + query.sum("erp_products_damage_record_details.quantity")

				return stock
			end
		#end

		if Erp::Core.available?("consignments")
      has_many :consignment_details, class_name: 'Erp::Consignments::ConsignmentDetail', dependent: :destroy

      # Get all consignment details
      def delivered_consignment_details
        consignment_details.joins(:consignment).
          where(erp_consignments_consignments: {
            status: Erp::Consignments::Consignment::STATUS_DELIVERED
          }
        )
      end

      # Get all consignment details
      def self.delivered_consignment_details
        Erp::Consignments::ConsignmentDetail.joins(:consignment).
          where(erp_consignments_consignments: {
            status: Erp::Consignments::Consignment::STATUS_DELIVERED
          }
        )
      end

			def self.get_consignment_query(params={})
        query = self.delivered_consignment_details

        # from date
        query = query.where("erp_consignments_consignment_details.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_consignments_consignment_details.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# warehouse
				query = query.where(erp_consignments_consignments: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				# state
				query = query.where(state_id: params[:state].id) if params[:state].present?
				# warehouse ids
				query = query.where(erp_consignments_consignments: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?
				# state ids
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				return query
      end

			# @todo export
			def self.get_consignment_export(params={})
        stock = 0

				main_query = self.get_consignment_query(params)

				# consignment detail with order detail
				query = main_query

				if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

				stock = stock + query.sum("erp_consignments_consignment_details.quantity")

				return stock
			end

			# Get all cs details
      def self.delivered_cs_return_details
        Erp::Consignments::ReturnDetail.joins(:cs_return).
          where(erp_consignments_cs_returns: {
            status: Erp::Consignments::CsReturn::STATUS_ACTIVE
          }
        )
      end

			def self.get_cs_return_query(params={})
        query = self.delivered_cs_return_details

        # from date
        query = query.where("erp_consignments_return_details.created_at >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_consignments_return_details.created_at <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# warehouse
				query = query.where(erp_consignments_cs_returns: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				# state
				query = query.where(state_id: params[:state].id) if params[:state].present?
				# warehouse ids
				query = query.where(erp_consignments_cs_returns: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?
				# state ids
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				return query
      end

			# @todo export
			def self.get_cs_return_import(params={})
        stock = 0

				main_query = self.get_cs_return_query(params)

				# consignment detail with order detail
				query = main_query.joins(:consignment_detail)

				if params[:product_id].present?
					query = query.where(erp_consignments_consignment_details: {product_id: params[:product_id]})
				end

				stock = stock + query.sum("erp_consignments_return_details.quantity")

				return stock
			end
		end

		if Erp::Core.available?("orders")
      # Get all consignment details
      def confirmed_order_details
        order_details.joins(:order).
          where(erp_orders_orders: {
            status: Erp::Orders::Order::STATUS_CONFIRMED
          }
        )
      end

      # Get all confirmed_order_details
      def self.confirmed_order_details
        Erp::Orders::OrderDetail.joins(:order).
          where(erp_orders_orders: {
            status: Erp::Orders::Order::STATUS_CONFIRMED
          }
        )
      end

			def self.get_order_query(params={})
        query = self.confirmed_order_details

        # from date
        query = query.where("erp_orders_orders.order_date >= ?", params[:from_date].to_date.beginning_of_day) if params[:from_date].present?
        query = query.where("erp_orders_orders.order_date <= ?", params[:to_date].to_date.end_of_day) if params[:to_date].present?

				# warehouse
				query = query.where(erp_orders_orders: {warehouse_id: params[:warehouse].id}) if params[:warehouse].present?
				# state
				query = query.where(state_id: params[:state].id) if params[:state].present?
				# warehouse ids
				query = query.where(erp_orders_orders: {warehouse_id: params[:warehouse_ids]}) if params[:warehouse_ids].present?
				# state ids
				query = query.where(state_id: params[:state_ids]) if params[:state_ids].present?

				return query
      end

			# @todo export
			def self.get_order_export(params={})
        stock = 0

				main_query = self.get_order_query(params)

				# consignment detail with order detail
				query = main_query.where(erp_orders_orders: {supplier_id: Erp::Contacts::Contact::MAIN_CONTACT_ID})

				if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

				stock = stock + query.sum("erp_orders_order_details.quantity")

				return stock
			end

			# @todo export
			def self.get_order_import(params={})
        stock = 0

				main_query = self.get_order_query(params)

				# consignment detail with order detail
				query = main_query.where(erp_orders_orders: {customer_id: Erp::Contacts::Contact::MAIN_CONTACT_ID})

				if params[:product_id].present?
					query = query.where(product_id: params[:product_id])
				end

				stock = stock + query.sum("erp_orders_order_details.quantity")

				return stock
			end
		end

    # get stock
    def get_stock(params={})
			stock = 0

			# Qdelivery
			if Erp::Core.available?("qdeliveries")
				stock += (
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_IMPORT, product_id: self.id)) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT, product_id: self.id)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_EXPORT, product_id: self.id)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_EXPORT, product_id: self.id)) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_IMPORT, product_id: self.id)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_EXPORT, product_id: self.id))
        )
			end

			# Transfer
			if Erp::Core.available?("stock_transfers")
				stock += Product.get_transfer_import(params.merge({product_id: self.id})) - Product.get_transfer_export(params.merge({product_id: self.id}))
			end

			# stock check
			stock += Product.get_stock_check_import(params.merge({product_id: self.id})) - Product.get_stock_check_export(params.merge({product_id: self.id}))

			# gift given
			stock -= Product.get_gift_given_export(params.merge({product_id: self.id}))

			# damange record
			stock -= Product.get_damage_record_export(params.merge({product_id: self.id}))

			# consignments
			if Erp::Core.available?("consignments")
        stock += Product.get_cs_return_import(params.merge({product_id: self.id}))
        stock -= Product.get_consignment_export(params.merge({product_id: self.id}))
      end

			return stock
		end

    # get stock
    def get_stock_virtual(params={})
			stock = 0

			# Qdelivery
			if Erp::Core.available?("orders")
				stock += (
          Product.get_order_import(params.merge({product_id: self.id})) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT, product_id: self.id)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_EXPORT, product_id: self.id)) -
          Product.get_order_export(params.merge({product_id: self.id})) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_IMPORT, product_id: self.id)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_EXPORT, product_id: self.id))
        )
			end

			# Transfer
			if Erp::Core.available?("stock_transfers")
				stock += Product.get_transfer_import(params.merge({product_id: self.id})) - Product.get_transfer_export(params.merge({product_id: self.id}))
			end

			# stock check
			stock += Product.get_stock_check_import(params.merge({product_id: self.id})) - Product.get_stock_check_export(params.merge({product_id: self.id}))

			# gift given
			stock -= Product.get_gift_given_export(params.merge({product_id: self.id}))

			# damange record
			stock -= Product.get_damage_record_export(params.merge({product_id: self.id}))

			# consignments
			if Erp::Core.available?("consignments")
        stock += Product.get_cs_return_import(params.merge({product_id: self.id}))
        stock -= Product.get_consignment_export(params.merge({product_id: self.id}))
      end

			return stock
		end

    # get stock
    def self.get_stock_real(params={})
			stock = 0

			# Qdelivery
			if Erp::Core.available?("qdeliveries")
				stock += (
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_IMPORT)) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_EXPORT)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_EXPORT)) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_IMPORT)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_EXPORT))
        )
			end

			# Transfer
			if Erp::Core.available?("stock_transfers")
				stock += Product.get_transfer_import(params) - Product.get_transfer_export(params)
			end

			# stock check
			stock += Product.get_stock_check_import(params) - Product.get_stock_check_export(params)

			# gift given
			stock -= Product.get_gift_given_export(params)

			# damange record
			stock -= Product.get_damage_record_export(params)

			# consignments
			if Erp::Core.available?("consignments")
        stock += Product.get_cs_return_import(params)
        stock -= Product.get_consignment_export(params)
      end

			return stock
		end

    # get stock
    def self.get_stock_virtual(params={})
			stock = 0

			# orders
			if Erp::Core.available?("orders")
        stock += (
          Product.get_order_import(params) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_SALES_IMPORT)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_PURCHASE_EXPORT)) -
          Product.get_order_export(params) +
          Product.get_qdelivery_import(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_IMPORT)) -
          Product.get_qdelivery_export(params.merge(delivery_type: Erp::Qdeliveries::Delivery::TYPE_CUSTOM_EXPORT))
        )
			end

			# Transfer
			if Erp::Core.available?("stock_transfers")
				stock += Product.get_transfer_import(params) - Product.get_transfer_export(params)
			end

			# stock check
			stock += Product.get_stock_check_import(params) - Product.get_stock_check_export(params)

			# gift given
			stock -= Product.get_gift_given_export(params)

			# damange record
			stock -= Product.get_damage_record_export(params)

			# consignments
			if Erp::Core.available?("consignments")
        stock += Product.get_cs_return_import(params)
        stock -= Product.get_consignment_export(params)
      end

			return stock
		end

    # stock status
		def stock_status
			if get_stock <= 0
				return OUT_OF_STOCK
			else
				return IN_TOCK
			end
		end

    def self.get_active
			self.where(archived: false)
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

      # global filter
      global_filter = params[:global_filter]

      if global_filter.present?

        @global_filters = global_filter

        # get categories
        category_ids = @global_filters[:categories].present? ? @global_filters[:categories] : nil
        @categories = Erp::Products::Category.where(id: category_ids)

        # get diameters
        diameter_ids = @global_filters[:diameters].present? ? @global_filters[:diameters] : nil
        @diameters = Erp::Products::PropertiesValue.where(id: diameter_ids)

        # get diameters
        letter_ids = @global_filters[:letters].present? ? @global_filters[:letters] : nil
        @letters = Erp::Products::PropertiesValue.where(id: letter_ids)

        # get numbers
        number_ids = @global_filters[:numbers].present? ? @global_filters[:numbers] : nil
        @numbers = Erp::Products::PropertiesValue.where(id: number_ids)

        # get degrees
        degree_ids = @global_filters[:degrees].present? ? @global_filters[:degrees] : nil
        @degrees = Erp::Products::PropertiesValue.where(id: degree_ids)

        # get numbers
        degree_k_ids = @global_filters[:degree_ks].present? ? @global_filters[:degree_ks] : nil
        @degree_ks = Erp::Products::PropertiesValue.where(id: degree_k_ids)

        # warehouses
        @warehouses = Erp::Warehouses::Warehouse.all


        # product query
        query = query.where(category_id: category_ids) if category_ids.present?
        # filter by diameters
        if diameter_ids.present?
          if !diameter_ids.kind_of?(Array)
            query = query.where("erp_products_products.cache_properties LIKE '%[\"#{diameter_ids}\",%'")
          else
            diameter_ids = (diameter_ids.reject { |c| c.empty? })
            if !diameter_ids.empty?
              qs = []
              diameter_ids.each do |x|
                qs << "(erp_products_products.cache_properties LIKE '%[\"#{x}\",%')"
              end
              query = query.where("(#{qs.join(" OR ")})")
            end
          end
        end
        # filter by letters
        if letter_ids.present?
          if !letter_ids.kind_of?(Array)
            query = query.where("erp_products_products.cache_properties LIKE '%[\"#{letter_ids}\",%'")
          else
            letter_ids = (letter_ids.reject { |c| c.empty? })
            if !letter_ids.empty?
              qs = []
              letter_ids.each do |x|
                qs << "(erp_products_products.cache_properties LIKE '%[\"#{x}\",%')"
              end
              query = query.where("(#{qs.join(" OR ")})")
            end
          end
        end
        # filter by numbers
        if number_ids.present?
          if !number_ids.kind_of?(Array)
            query = query.where("erp_products_products.cache_properties LIKE '%[\"#{number_ids}\",%'")
          else
            number_ids = (number_ids.reject { |c| c.empty? })
            if !number_ids.empty?
              qs = []
              number_ids.each do |x|
                qs << "(erp_products_products.cache_properties LIKE '%[\"#{x}\",%')"
              end
              query = query.where("(#{qs.join(" OR ")})")
            end
          end
        end
        # filter by degrees
        if degree_ids.present?
          if !degree_ids.kind_of?(Array)
            query = query.where("erp_products_products.cache_properties LIKE '%[\"#{degree_ids}\",%'")
          else
            degree_ids = (degree_ids.reject { |c| c.empty? })
            if !degree_ids.empty?
              qs = []
              degree_ids.each do |x|
                qs << "(erp_products_products.cache_properties LIKE '%[\"#{x}\",%')"
              end
              query = query.where("(#{qs.join(" OR ")})")
            end
          end
        end
        # filter by degree_ks
        if degree_k_ids.present?
          if !degree_k_ids.kind_of?(Array)
            query = query.where("erp_products_products.cache_properties LIKE '%[\"#{degree_k_ids}\",%'")
          else
            degree_k_ids = (degree_k_ids.reject { |c| c.empty? })
            if !degree_k_ids.empty?
              qs = []
              degree_k_ids.each do |x|
                qs << "(erp_products_products.cache_properties LIKE '%[\"#{x}\",%')"
              end
              query = query.where("(#{qs.join(" OR ")})")
            end
          end
        end

			end
      # end// global filter

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
					query = query.where('LOWER(erp_products_products.cache_search) LIKE ?', '%'+q+'%')
				end
			end

			if Erp::Core.available?("menus")
				# menu id
				if params[:menu_id].present?
					menu = Erp::Menus::Menu.find(params[:menu_id])
					query = query.where(category_id: menu.get_all_related_category_ids)
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
      else
				query = query.order('erp_products_products.created_at desc')
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='', params={})
      query = self.all

      # single keyword
      if keyword.present?
				keyword = keyword.strip.downcase
				keyword.split(' ').each do |q|
					q = q.strip
					query = query.where('LOWER(erp_products_products.name) LIKE ?', '%'+q+'%')
				end
			end

			if Erp::Core.available?("orders")
				# product from order
				if params[:order_id].present?
					query = query.includes(:order_details)
						.where(erp_orders_order_details: {order_id: params[:order_id]})

					if Erp::Core.available?("qdeliveries")
						if params[:delivery_type].present?
							if [Erp::Qdeliveries::Delivery::TYPE_SALES_EXPORT, Erp::Qdeliveries::Delivery::TYPE_PURCHASE_IMPORT].include?(params[:delivery_type])
								query = query.where(erp_orders_order_details: {cache_delivery_status: Erp::Orders::OrderDetail::DELIVERY_STATUS_NOT_DELIVERY})
							end
						end
					end
				end
			end

      query = query.order(:name).limit(80).map{|product| {value: product.id, text: product.name} }
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

    # set is call
    def check_is_call
			update_columns(is_call: true)
		end

    def uncheck_is_call
			update_columns(is_call: false)
		end

    def self.check_is_call_all
			update_all(is_call: true)
		end

    def self.uncheck_is_call_all
			update_all(is_call: false)
		end

    # set is sold out
    def check_is_sold_out
			update_columns(is_sold_out: true)

			if Erp::Core.available?("online_store")
        self.hkerp_set_sold_out
      end
		end

    def uncheck_is_sold_out
			update_columns(is_sold_out: false)

			if Erp::Core.available?("online_store")
        self.hkerp_set_sold_out
      end
		end

    def self.check_is_sold_out_all
			update_all(is_sold_out: true)
		end

    def self.uncheck_is_sold_out_all
			update_all(is_sold_out: false)
		end

    # set is stock inventory
    def check_is_stock_inventory
			update_columns(is_stock_inventory: true)
		end

    def uncheck_is_stock_inventory
			update_columns(is_stock_inventory: false)
		end

    def self.check_is_stock_inventory_all
			update_all(is_stock_inventory: true)
		end

    def self.uncheck_is_stock_inventory_all
			update_all(is_stock_inventory: false)
		end

    # set is business choices
    def check_is_business_choices
			update_columns(is_business_choices: true)
		end

    def uncheck_is_business_choices
			update_columns(is_business_choices: false)
		end

    def self.check_is_business_choices_all
			update_all(is_business_choices: true)
		end

    def self.uncheck_is_business_choices_all
			update_all(is_business_choices: false)
		end

    # set is top business choices
    def check_is_top_business_choices
			update_columns(is_top_business_choices: true)
		end

    def uncheck_is_top_business_choices
			update_columns(is_top_business_choices: false)
		end

    def self.check_is_top_business_choices_all
			update_all(is_top_business_choices: true)
		end

    def self.uncheck_is_top_business_choices_all
			update_all(is_top_business_choices: false)
		end

    # creator name
    def creator_name
			creator.present? ? creator.name : ''
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

    # safe properties values from hash
    def update_products_values
			if self.product_property_values.present?
				# get all property value ids
				properties_value_ids = []

				# save new properties values
				self.product_property_values.each do |row|
					row = row[1]
					# exist ones
					properties_value_ids += row['ids'].select {|id| id.to_i > 0} if row['ids'].present?
					# new one from names
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

				# add product values
				self.products_values.destroy_all
				properties_value_ids.each do |prv_id|
					self.products_values.create(properties_value_id: prv_id)
				end
			end
		end

    # safe properties values from hash
    def update_products_valuesx
			if self.product_property_values.present?
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

    def self.get_stock_inventory_products
			self.get_active.where(is_stock_inventory: true)
		end

    def product_price
			# product is not deal
			return self.price if !self.is_deal
			# product is deal
			from_conds = !self.deal_from_date.present? || (self.deal_from_date.present? && Time.now >= self.deal_from_date.beginning_of_day)
			to_conds = !self.deal_to_date.present? || (self.deal_to_date.present? && Time.now <= self.deal_to_date.end_of_day)
			if from_conds && to_conds
				return self.deal_price
			else
				# auto uncheck is_deal
				self.update_column(:is_deal, false)
				return self.price
			end
		end

    # get product price
    def get_price
			return self.price
		end

    def product_name
			return self.short_name
		end

    # get product properties array
    def get_product_property_array
			arr = []
			self.properties.each do |property|
				row = {
					name: property.name,
					values: self.products_values_by_property(property).map {|products_value|
						products_value.properties_value.value
					}
				}
				arr << row
			end
			arr
		end

    # get properties
    def properties
			Property.where(id: (self.products_values.joins(:properties_value).select("erp_products_properties_values.property_id as property_id").map {|pv| pv.property_id}).uniq)
		end

		def ratings_active
			ratings.where(archived: false)
		end

    # count stars
		def count_stars
			self.ratings_active.map(&:star)
		end

		# average stars
		def average_stars
			# calculate average stars
			(count_stars.empty? ? 0 : count_stars.inject(0, :+).to_f / count_stars.length).round(1)
		end

		def percentage_stars(score=0)
			percentage=0
			num = self.ratings_active.where(star: score).count
			if num > 0
				percentage = num*100 / count_stars.length
			end
			return percentage
		end

		after_save :update_cache_search
		after_create :create_alias

		def update_cache_search
			str = []
			str << code.to_s.downcase.strip
			str << name.to_s.downcase.strip
			str << short_name.to_s.downcase.strip
			str << brand_name.to_s.downcase.strip
			str << category_name.to_s.downcase.strip

			self.update_column(:cache_search, str.join(" ") + " " + str.join(" ").to_ascii)
		end

		def create_alias
			name = self.short_name.present? ? self.short_name : self.name
			self.update_column(:alias, name.to_ascii.downcase.to_s.gsub(/[^0-9a-z ]/i, '').gsub(/ +/i, '-').strip)
		end

		def products_values_by_property(property)
			self.products_values.joins(:properties_value).where(erp_products_properties_values: {property_id: property.id})
		end

		# Get full product properties array
		def product_values_array
			groups = []
			self.category.property_groups.each do |group|
				row = {}
				row[:group] = group
				row[:properties] = []
				group.properties.each do |property|
					row2 = {}
					row2[:property] = property
					row2[:values] = self.products_values_by_property(property).map {|pv| pv.properties_value.value }

					row[:properties] << row2 if !row2[:values].empty?
				end

				groups << row if !row[:properties].empty?
			end

			return groups
		end

		# Get product properties short description
		def product_short_descipriton_values_array
			groups = []
      return [] if self.category.nil?
			self.category.property_groups.each do |group|
				row = {}
				row[:name] = group.name
				row[:values] = []
				group.properties.where(is_show_detail: true).each do |property|
					values = self.products_values_by_property(property).map {|pv| pv.properties_value.value }
					row[:values] += values if !values.empty?
				end
				groups << row if !row[:values].empty?
			end

			return groups
		end

		# Get product properties for list
		def product_list_descipriton_values_array_1
			rows = []
      return [] if self.category.nil?
			self.category.property_groups.each do |group|
				group.properties.where(is_show_list: true).each do |property|
					row = {}
					row[:name] = property.name
					values = self.products_values_by_property(property).map {|pv| pv.properties_value.value }
					row[:values] = values if !values.empty?

					rows << row if !row[:values].empty?
				end
			end

			return rows
		end

		# Get product properties for list
		def product_list_descipriton_values_array
			groups = []
      return [] if self.category.nil?
			self.category.property_groups.each do |group|
				row = {}
				row[:name] = group.name
				row[:values] = []
				group.properties.where(is_show_list: true).each do |property|
					values = self.products_values_by_property(property).map {|pv| pv.properties_value.value }
					row[:values] += values if !values.empty?
				end
				groups << row if !row[:values].empty?
			end

			return groups
		end

		def deal_to_date_cannot_be_in_the_past
			if deal_from_date.present? && deal_to_date.present?
				errors.add(:deal_to_date, :cannot_be_in_the_past_msg) unless deal_to_date > Time.now.utc.in_time_zone("Hanoi") # @todo: time_zone dùng chung hàm cho toàn hệ thống
				errors.add(:deal_to_date, :cannot_happen_before_from_date_msg) unless deal_to_date > deal_from_date
			end
		end

		def deal_price_cannot_blank
			if is_deal == true
				errors.add(:deal_price, :cannot_blank_msg) unless !deal_price.nil?
				errors.add(:deal_percent, :cannot_blank_msg) unless !deal_percent.nil?
			end
		end

		def self.get_products_for_brand(params)
			self.get_active.where(brand_id: params[:brand_id])
		end

		def get_related_events(time_now)
			self.events.where("from_date <= ? AND to_date >= ?", time_now.beginning_of_day, time_now.end_of_day)
		end

		# update cache properties
		def update_cache_properties
			arr = {}
			self.products_values.each do |pv|
				arr[pv.properties_value.property_id] = [pv.properties_value_id.to_s, pv.properties_value.value] # "[#{pv.properties_value_id}]"
			end
			self.update_column(:cache_properties, arr.to_json)
			self.cache_properties = arr.to_json
		end

		def get_stock_by_warehouse(warehouse)
			return rand(0..100)
		end

		# Get category name
		def category_name
			category.nil? ? '' : category.name
		end

		# data for dataselect ajax
    def self.dataselect_code(params={})
      query = self.all

      if params[:keyword].present?
        keyword = params[:keyword].strip.downcase
        query = query.where('LOWER(code) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).pluck(:code).uniq

      query = query.map{|code| {value: code, text: code} }
    end
  end
end
