module Erp
  module Products
    module Backend
      class EventsProductsController < Erp::Backend::BackendController
        def event_product_line_form
          @events_product = EventsProduct.new
          @events_product.product_id = params[:add_value]
          
          render partial: params[:partial], locals: {
            events_product: @events_product,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
