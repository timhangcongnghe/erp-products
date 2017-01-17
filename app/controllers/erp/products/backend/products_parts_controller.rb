require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class ProductsPartsController < Erp::Backend::BackendController
        before_action :set_products_part, only: [:show, :edit, :update, :destroy]
    
        # GET /products_parts
        def index
          @products_parts = ProductsPart.all
        end
    
        # GET /products_parts/1
        def show
        end
    
        # GET /products_parts/new
        def new
          @products_part = ProductsPart.new
        end
    
        # GET /products_parts/1/edit
        def edit
        end
    
        # POST /products_parts
        def create
          @products_part = ProductsPart.new(products_part_params)
          @products_part.creator = current_user
    
          if @products_part.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @products_part.name,
                value: @products_part.id
              }
            else
              redirect_to erp_products.edit_backend_products_part_path(@products_part), notice: t('.success')
            end
          else
            render :new
          end
        end
    
        # PATCH/PUT /products_parts/1
        def update
          if @products_part.update(products_part_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @products_part.name,
                value: @products_part.id
              }
            else
              redirect_to erp_products.edit_backend_products_part_path(@products_part), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /products_parts/1
        def destroy
          @products_part.destroy
          redirect_to products_parts_url, notice: 'Products part was successfully destroyed.'
        end
        
        def part_form
          @products_part = ProductsPart.new
          @products_part.part_id = params[:add_value]
          
          render partial: params[:partial], locals: {
            products_part: @products_part,
            uid: helpers.unique_id()
          }          
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_products_part
            @products_part = ProductsPart.find(params[:id])
          end
    
          # Only allow a trusted parameter "white list" through.
          def products_part_params
            params.fetch(:products_part, {}).permit(:product_id, part_id, :quantity, :total)
          end
      end
    end
  end
end
