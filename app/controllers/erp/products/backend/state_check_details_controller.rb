module Erp
  module Products
    module Backend
      class StateCheckDetailsController < Erp::Backend::BackendController
        def state_check_detail_line_form
          @state_check_detail = StateCheckDetail.new
          @state_check_detail.product_id = params[:add_value]
          @state_check_detail.old_state_id = params[:form][:default_state] if params[:form].present?

          render partial: params[:partial], locals: {
            state_check_detail: @state_check_detail,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
