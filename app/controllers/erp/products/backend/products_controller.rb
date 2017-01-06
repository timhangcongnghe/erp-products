require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class ProductsController < Erp::Backend::BackendController
        before_action :set_product, only: [:archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_products, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /products
        def index
        end
        
        # POST /products/list
        def list
          @products = Product.search(params).paginate(:page => params[:page], :per_page => 3)
          
          render layout: nil
        end
      
        # GET /products/1
        def show
        end
      
        # GET /products/new
        def new
          @product = Product.new
          @product.products_properties << ProductsProperty.new
          4.times do
            @product.product_images.build
          end
        end
      
        # GET /products/1/edit
        def edit
          # default product images
          (4 - @product.product_images.count).times do
            @product.product_images.build
          end
        end
      
        # POST /products
        def create
          @product = Product.new(product_params)
          @product.creator = current_user
          @product.products_values_attributes = params.to_unsafe_hash[:products_values_attributes]
          
          if @product.save
            @product.update_products_values
            
            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }              
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: t('.success')
            end            
          else
            # default product images
            render :new
          end
        end
      
        # PATCH/PUT /products/1
        def update
          @product.products_values_attributes = params.to_unsafe_hash[:products_values_attributes]
          
          if @product.update(product_params)
            @product.update_products_values
            
            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }              
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: t('.success')
            end            
          else
            render :edit
          end
        end
      
        # DELETE /products/1
        def destroy
          @product.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_products_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Archive /products/archive?id=1
        def archive      
          @product.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Unarchive /products/unarchive?id=1
        def unarchive
          @product.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # DELETE /products/delete_all?ids=1,2,3
        def delete_all         
          @products.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /products/archive_all?ids=1,2,3
        def archive_all         
          @products.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /products/unarchive_all?ids=1,2,3
        def unarchive_all
          @products.unarchive_all
          
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
              render json: Product.dataselect(params[:keyword])
            }
          end
        end
        
        def form_property
          render partial: params[:partial], locals: { products_values_attribute: {1 => {}}, uid: helpers.unique_id() }
        end
      
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_product
            @product = Product.find(params[:id])
          end
          
          def set_products
            @products = Product.where(id: params[:ids])
          end
      
          # Only allow a trusted parameter "white list" through.
          def product_params
            params.fetch(:product, {}).permit(
              :name, :can_be_sold, :can_be_purchased, :product_type, :barcode,
              :price, :cost, :on_hand, :weight, :volume, :is_for_pos, :unit_id,
              :stock_min, :stock_max, :description, :internal_note, :point_enabled, :category_id,              
              customer_tax_ids: [], vendor_tax_ids: [],
              :product_images_attributes => [ :id, :image_url, :image_url_cache, :product_id, :_destroy ]
              )
          end
      end
    end
  end
end
