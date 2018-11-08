module Erp::Products
  class StockCheckDetail < ApplicationRecord
    belongs_to :product
    belongs_to :stock_check, inverse_of: :stock_check_details
    belongs_to :state, class_name: "Erp::Products::State"
    validates :stock_check, presence: true
    
    after_save :update_product_cache_stock

    # update product cache stock
    def update_product_cache_stock
			self.product.update_cache_stock if self.product.present?
		end
    
    def product_code
      product.nil? ? '' : product.code
    end
    
    def product_name
      product.nil? ? '' : product.name
    end
    
    def product_unit
      product.nil? ? '' : product.unit_name
    end
    
    def state_name
      state.nil? ? '' : state.name
    end
    
		# total stock
		def self.total_stock
      self.sum(:stock)
    end
    
		# total real
		def self.total_real
      self.sum(:real)
    end
    
		# total quantity
		def self.total_quantity
      self.sum(:quantity)
    end
		
		def quantity=(new_price)
      self[:quantity] = new_price.to_s.gsub(/\,/, '')
    end
    
    def real=(new_price)
      self[:real] = new_price.to_s.gsub(/\,/, '')
    end
    
    def stock=(new_price)
      self[:stock] = new_price.to_s.gsub(/\,/, '')
    end
  end
end
