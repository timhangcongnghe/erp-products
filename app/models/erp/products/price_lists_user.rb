module Erp::Products
  class PriceListsUser < ApplicationRecord
    belongs_to :price_list
    belongs_to :user
  end
end
