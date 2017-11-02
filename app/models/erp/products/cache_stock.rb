module Erp::Products
  class CacheStock < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product', optional: true
    belongs_to :state, class_name: 'Erp::Products::State', optional: true
    belongs_to :warehouse, class_name: 'Erp::Warehouses::Warehouse', optional: true

    def self.update_stock(product, value, options={})
      exist = self.where(product_id: product.id, state_id: options[:state_id], warehouse_id: options[:warehouse_id]).first
      if !exist.nil?
        exist.update_attribute(:stock, value)
      else
        self.create(
          product_id: product.id,
          state_id: options[:state_id],
          warehouse_id: options[:warehouse_id],
          stock: value
        )
      end
    end

    def self.get_stock(products, options={})
      query = self.filter(products, options)

      return query.sum(:stock)
    end

    def self.filter(products, options={})
      query = self.where(product_id: products)

      sts = options[:state_id].present? ? options[:state_id] : nil
      query = query.where(state_id: sts)

      whs = options[:warehouse_id].present? ? options[:warehouse_id] : nil
      query = query.where(warehouse_id: whs)

      return query
    end
  end
end
