module Erp
  module Products
    module Backend
      class InventoryProductsController < Erp::Backend::BackendController
        before_action :set_inventory_product, only: [:move_up, :move_down, :archive, :unarchive, :edit, :update, :destroy]
        before_action :set_inventory_products, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /inventory_products
        def index
        end

        # POST /inventory_products/list
        def list
          @inventory_products = InventoryProduct.search(params).paginate(:page => params[:page], :per_page => 20)

          render layout: nil
        end

        # GET /inventory_products/new
        def new
          @inventory_product = InventoryProduct.new
        end

        # GET /inventory_products/1/edit
        def edit
        end

        # POST /inventory_products
        def create
          @inventory_product = InventoryProduct.new(inventory_product_params)
          @inventory_product.creator = current_user
          if @inventory_product.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @inventory_product.name,
                value: @inventory_product.id
              }
            else
              redirect_to erp_products.edit_backend_inventory_product_path(@inventory_product), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /inventory_products/1
        def update
          if @inventory_product.update(inventory_product_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @inventory_product.name,
                value: @inventory_product.id
              }
            else
              redirect_to erp_products.edit_backend_inventory_product_path(@inventory_product), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /inventory_products/1
        def destroy
          @inventory_product.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_inventory_products_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE /inventory_products/archive?id=1
        def archive
          @inventory_product.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE /inventory_products/archive?id=1
        def unarchive
          @inventory_product.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE ALL /inventory_products/delete_all?ids=1,2,3
        def delete_all
          @inventory_products.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE ALL /inventory_products/archive_all?ids=1,2,3
        def archive_all
          @inventory_products.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE ALL /inventory_products/unarchive_all?ids=1,2,3
        def unarchive_all
          @inventory_products.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: InventoryProduct.dataselect(params[:keyword].strip)
            }
          end
        end

        # Move up /inventory_products/up?id=1
        def move_up
          @inventory_product.move_up

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end
        end

        # Move down /inventory_products/up?id=1
        def move_down
          @inventory_product.move_down

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_inventory_product
            @inventory_product = InventoryProduct.find(params[:id])
          end

          def set_inventory_products
            @inventory_products = InventoryProduct.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def inventory_product_params
            params.fetch(:inventory_product, {}).permit(:image_url, :name, :price, :gift, :inventory_category_id,
                                                        :product_link, :is_stock, :hot_category_name)
          end
      end
    end
  end
end