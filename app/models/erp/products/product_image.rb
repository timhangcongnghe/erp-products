module Erp::Products
  class ProductImage < ApplicationRecord
    belongs_to :product, optional: true, dependent: :destroy
    mount_uploader :image_url, Erp::Products::ProductImageUploader
  end
end
