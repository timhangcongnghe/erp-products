module Erp::Products
  class RelatedCategory < ApplicationRecord
    belongs_to :category
  end
end
