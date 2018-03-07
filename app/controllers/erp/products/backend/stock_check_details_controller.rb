module Erp
  module Products
    module Backend
      class StockCheckDetailsController < Erp::Backend::BackendController
        before_action :set_stock_check_detail, only: [:inline_update, :delete]

        def stock_check_line_form
          @stock_check_detail = StockCheckDetail.new
          @stock_check_detail.product_id = params[:add_value]

          @stock_check_detail.state = ((params[:form].present? and params[:form][:default_state].present?) ? Erp::Products::State.find(params[:form][:default_state]) : nil)

          render partial: params[:partial], locals: {
            stock_check_detail: @stock_check_detail,
            uid: helpers.unique_id()
          }
        end

        def inline_update
          if @stock_check_detail.update(stock_check_detail_params)

            @stock_check_detail.quantity = @stock_check_detail.real - @stock_check_detail.stock
            @stock_check_detail.save

            if request.xhr?
              render json: {
                status: 'success',
                text: '',
                value: ''
              }
            end
          end
        end

        def delete
          if @stock_check_detail.destroy
            if request.xhr?
              render json: {
                status: 'success',
                text: '',
                value: ''
              }
            end
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_stock_check_detail
            @stock_check_detail = StockCheckDetail.find(params[:id])
          end
          # Only allow a trusted parameter "white list" through.
          def stock_check_detail_params
            params.fetch(:stock_check_detail, {}).permit(:real)
          end
      end
    end
  end
end
