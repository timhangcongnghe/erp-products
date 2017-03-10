module Erp
  module Products
    module Backend
      class PropertiesController < Erp::Backend::BackendController
        before_action :set_property, only: [:edit, :update, :destroy]
        
        # GET /properties/new
        def new
          @property = Property.new
        end
        
        # GET /categories/1/edit
        def edit
        end
    
        # POST /categories
        def create
          @property = Property.new(property_params)
          @property.creator = current_user
          
          if @property.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @property.name,
                value: @property.id
              }
            else
              redirect_to erp_products.edit_backend_property_path(@property), notice: t('.success')
            end
          else
            render :new
          end
        end
    
        # PATCH/PUT /categories/1
        def update
          if @property.update(property_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @property.name,
                value: @property.id
              }
            else
              redirect_to erp_products.edit_backend_property_path(@property), notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: Property.dataselect(params[:keyword])
            }
          end
        end
        
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_property
            @property = Property.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def property_params
            params.fetch(:property, {}).permit(:name)
          end
      end
    end
  end
end
