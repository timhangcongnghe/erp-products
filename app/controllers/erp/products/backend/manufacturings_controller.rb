require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class ManufacturingsController < Erp::Backend::BackendController
        before_action :set_manufacturing, only: [:show, :edit, :update, :destroy]
        before_action :set_manufacturings, only: [:delete_all]
    
        # GET /manufacturings
        def index
        end
    
        # GET /manufacturings/1
        def list
          @manufacturings = Manufacturing.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /manufacturings/new
        def new
          @manufacturing = Manufacturing.new
          @manufacturing.manufacturing_date = Time.now
        end
    
        # GET /manufacturings/1/edit
        def edit
          
        end
    
        # POST /manufacturings
        def create
          @manufacturing = Manufacturing.new(manufacturing_params)
          @manufacturing.creator = current_user
          
          if @manufacturing.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @manufacturing.code,
                value: @manufacturing.id
              }              
            else
              redirect_to erp_products.edit_backend_manufacturing_path(@manufacturing), notice: t('.success')
            end            
          else
            puts @manufacturing.errors.to_json
            render :new
          end
        end
    
        # PATCH/PUT /manufacturings/1
        def update
          if @manufacturing.update(manufacturing_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @manufacturing.code,
                value: @manufacturing.id
              }              
            else
              redirect_to erp_products.edit_backend_manufacturing_path(@manufacturing), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /manufacturings/1
        def destroy
          @manufacturing.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_manufacturings_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE /manufacturings/delete_all?ids=1,2,3
        def delete_all         
          @manufacturings.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_manufacturing
            @manufacturing = Manufacturing.find(params[:id])
            
          end
          
          def set_manufacturings
            @manufacturings = Manufacturing.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def manufacturing_params
            params.fetch(:manufacturing, {}).permit(:code, :manufacturing_date, :product_id, :quantity,
                                                    :is_auto_reduce_part_quantity, :note, :responsible_id)
          end
      end
    end
  end
end
