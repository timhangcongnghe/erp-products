module Erp::Products
  class ProductImage < ApplicationRecord
    mount_uploader :image_url, Erp::Products::ProductImageUploader
    belongs_to :product, class_name: 'Erp::Products::Product', optional: true
    default_scope {order(id: :desc)}
  end
end