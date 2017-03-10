module Erp
  module Products
    module Backend
      class PropertiesValuesController < Erp::Backend::BackendController
        before_action :set_properties_value, only: [:edit, :update, :destroy]
        
        # GET /properties/new
        def new
          @properties_value = PropertiesValue.new
        end
        
        # GET /categories/1/edit
        def edit
        end
    
        # POST /categories
        def create
          @properties_value = PropertiesValue.new(properties_value_params)
          @properties_value.creator = current_user
          
          if @properties_value.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @properties_value.name,
                value: @properties_value.id
              }
            else
              redirect_to erp_products.edit_backend_properties_value_path(@properties_value), notice: t('.success')
            end
          else
            render :new
          end
        end
    
        # PATCH/PUT /categories/1
        def update
          if @properties_value.update(properties_value_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @properties_value.name,
                value: @properties_value.id
              }
            else
              redirect_to erp_products.edit_backend_properties_value_path(@properties_value), notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: PropertiesValue.dataselect(params[:keyword], params)
            }
          end
        end
        
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_properties_value
            @properties_value = PropertiesValue.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def properties_value_params
            params.fetch(:properties_value, {}).permit(:name)
          end
      end
    end
  end
end
