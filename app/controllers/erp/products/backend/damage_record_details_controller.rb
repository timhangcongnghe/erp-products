module Erp
  module Products
    module Backend
      class DamageRecordDetailsController < Erp::Backend::BackendController
        def damage_record_line_form
          @damage_record_detail = DamageRecordDetail.new
          @damage_record_detail.product_id = params[:add_value]
          @damage_record_detail.state = Erp::Products::State.first

          @damage_record_detail.state = (params[:form].present? and params[:form][:default_state].present? ? Erp::Products::State.find(params[:form][:default_state]) : nil)

          render partial: params[:partial], locals: {
            damage_record_detail: @damage_record_detail,
            uid: helpers.unique_id()
          }
        end
      end
    end
  end
end
