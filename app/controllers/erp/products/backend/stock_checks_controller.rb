module Erp
  module Products
    module Backend
      class StockChecksController < Erp::Backend::BackendController
        before_action :set_stock_check, only: [:stock_check_confirm, :archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_stock_checks, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /stock_checks
        def index
        end
        
        # POST /stock_checks/list
        def list
          @stock_checks = StockCheck.search(params).paginate(:page => params[:page], :per_page => 3)
          
          render layout: nil
        end
    
        # GET /stock_checks/1
        def show
        end
    
        # GET /stock_checks/new
        def new
          @stock_check = StockCheck.new
          @stock_check.adjustment_date = Time.now
        end
    
        # GET /stock_checks/1/edit
        def edit
        end
    
        # POST /stock_checks
        def create
          @stock_check = StockCheck.new(stock_check_params)
          @stock_check.creator = current_user
    
          if @stock_check.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @stock_check.code,
                value: @stock_check.id
              }
            else
              redirect_to erp_products.edit_backend_stock_check_path(@stock_check), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /stock_checks/1
        def update
          if @stock_check.update(stock_check_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @stock_check.code,
                value: @stock_check.id
              }              
            else
              redirect_to erp_products.edit_backend_stock_check_path(@stock_check), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /stock_checks/1
        def destroy
          @stock_check.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_stock_checks_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        def archive
          @stock_check.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        def unarchive
          @stock_check.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        # DELETE /stock_checks/delete_all?ids=1,2,3
        def delete_all         
          @stock_checks.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /stock_checks/archive_all?ids=1,2,3
        def archive_all         
          @stock_checks.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /stock_checks/unarchive_all?ids=1,2,3
        def unarchive_all
          @stock_checks.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Confirm /stock_checks/stock_check_confirm?id=1
        def stock_check_confirm
          @stock_check.stock_check_confirm
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end 
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: StockCheck.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_stock_check
            @stock_check = StockCheck.find(params[:id])
          end
          
          def set_stock_checks
            @stock_checks = StockCheck.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def stock_check_params
            params.fetch(:stock_check, {}).permit(:code, :adjustment_date, :warehouse_id, :description,
                                            :stock_check_details_attributes => [ :id, :product_id, :stock_check_id, :quantity, :note, :_destroy ])
          end
      end
    end
  end
end