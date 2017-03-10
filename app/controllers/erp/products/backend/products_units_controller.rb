module Erp
  module Products
    module Backend
      class ProductsUnitsController < Erp::Backend::BackendController
        before_action :set_products_unit, only: [:edit, :update, :destroy]
        
        # GET /products_units/new
        def new
          @products_unit = ProductsUnit.new
        end
        
        # GET /products_units/1/edit
        def edit
        end
    
        # POST /products_units
        def create
          @products_unit = ProductsUnit.new(products_unit_params)
          @products_unit.creator = current_user
          
          if @products_unit.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @products_unit.name,
                value: @products_unit.id
              }
            else
              redirect_to erp_products.edit_backend_products_unit_path(@products_unit), notice: t('.success')
            end
          else
            render :new
          end
        end
    
        # PATCH/PUT /categories/1
        def update
          if @products_unit.update(products_unit_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @products_unit.name,
                value: @products_unit.id
              }
            else
              redirect_to erp_products.edit_backend_products_unit_path(@products_unit), notice: t('.success')
            end
          else
            render :edit
          end
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: ProductsUnit.dataselect(params[:keyword], params)
            }
          end
        end
        
        def form_line
          @products_unit = ProductsUnit.new
          render partial: params[:partial], locals: { products_unit: @products_unit, uid: helpers.unique_id() }
        end
        
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_products_unit
            @products_unit = ProductsUnit.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def products_unit_params
            params.fetch(:products_unit, {}).permit(:unit_id, :product_id, :conversion_value, :price, :code)
          end
      end
    end
  end
end
