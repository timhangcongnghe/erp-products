require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class UnitsController < Erp::Backend::BackendController
        before_action :set_unit, only: [:edit, :update, :destroy]
    
        # GET /units/new
        def new
          @unit = Unit.new
        end
    
        # GET /units/1/edit
        def edit
        end
    
        # POST /units
        def create
          @unit = Unit.new(unit_params)
          @unit.creator = current_user
          
          if @unit.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @unit.name,
                value: @unit.id
              }
            else
              redirect_to erp_products.edit_backend_unit_path(@unit), notice: t('.success')
            end
          else
            render :new
          end
        end
    
        # PATCH/PUT /units/1
        def update
          if @unit.update(unit_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @unit.name,
                value: @unit.id
              }
            else
              redirect_to erp_products.edit_backend_unit_path(@unit), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /units/1
        def destroy
          @unit.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_units_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # dataselect /units
        def dataselect
          respond_to do |format|
            format.json {
              render json: Unit.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_unit
            @unit = Unit.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def unit_params
            params.fetch(:unit, {}).permit(:name)
          end
      end
    end
  end
end
