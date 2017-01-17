module Erp::Products
  class ProductsPart < ApplicationRecord
    belongs_to :product
    belongs_to :part, class_name: 'Erp::Products::Product'#, optional: true
    
    def part_name
      part.nil? ? '' : part.name
    end
    
    def part_cost
      part.nil? ? '' : part.cost
    end
    
    def part_code
      part.nil? ? '' : part.code
    end
    def part_on_hand
      part.nil? ? '' : part.on_hand
    end
  end
end