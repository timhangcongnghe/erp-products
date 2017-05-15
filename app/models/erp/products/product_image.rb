module Erp::Products
  class ProductImage < ApplicationRecord
    belongs_to :product, optional: true
    mount_uploader :image_url, Erp::Products::ProductImageUploader

    default_scope { order(id: :desc) }
  end
end
