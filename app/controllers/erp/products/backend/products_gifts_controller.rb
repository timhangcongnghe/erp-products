module Erp
  module Products
    module Backend
      class ProductsGiftsController < Erp::Backend::BackendController
        def gift_form
          @products_gift = ProductsGift.new
          @products_gift.gift_id = params[:add_value]
          render partial: params[:partial], locals: {
            products_gift: @products_gift,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
