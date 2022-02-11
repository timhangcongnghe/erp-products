module Erp
  module Products
    module Backend
      class AccessoryDetailsController < Erp::Backend::BackendController
        def accessory_detail_line_form
          @accessory_detail = AccessoryDetail.new
          @accessory_detail.product_id = params[:add_value]
          render partial: params[:partial], locals: {accessory_detail: @accessory_detail, uid: helpers.unique_id()}
        end
      end
    end
  end
end