module Erp::Products
  class PriceListsWarehouse < ApplicationRecord
    belongs_to :price_list
    belongs_to :warehouse
  end
end
