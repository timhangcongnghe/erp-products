module Erp
  module Products
    module Backend
      class BrandGroupDetailsController < Erp::Backend::BackendController
        def brand_group_detail_line_form
          @brand_group_detail = BrandGroupDetail.new
          @brand_group_detail.brand_id = params[:add_value]
          
          render partial: params[:partial], locals: {
            brand_group_detail: @brand_group_detail,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
