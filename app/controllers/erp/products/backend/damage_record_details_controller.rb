module Erp
  module Products
    module Backend
      class DamageRecordDetailsController < Erp::Backend::BackendController
        def damage_record_line_form
          @damage_record_detail = DamageRecordDetail.new
          @damage_record_detail.product_id = params[:add_value]
          
          render partial: params[:partial], locals: {
            damage_record_detail: @damage_record_detail,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
