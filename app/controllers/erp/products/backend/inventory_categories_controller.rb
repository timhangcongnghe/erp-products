module Erp
  module Products
    module Backend
      class InventoryCategoriesController < Erp::Backend::BackendController
        before_action :set_inventory_category, only: [:move_up, :move_down, :archive, :unarchive, :edit, :update, :destroy]
        before_action :set_inventory_categories, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /inventory_categories
        def index
        end

        # POST /inventory_categories/list
        def list
          @inventory_categories = InventoryCategory.search(params).paginate(:page => params[:page], :per_page => 20)

          render layout: nil
        end

        # GET /inventory_categories/new
        def new
          @inventory_category = InventoryCategory.new
        end

        # GET /inventory_categories/1/edit
        def edit
        end

        # POST /inventory_categories
        def create
          @inventory_category = InventoryCategory.new(inventory_category_params)
          @inventory_category.creator = current_user
          if @inventory_category.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @inventory_category.name,
                value: @inventory_category.id
              }
            else
              redirect_to erp_products.edit_backend_inventory_category_path(@inventory_category), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /inventory_categories/1
        def update
          if @inventory_category.update(inventory_category_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @inventory_category.name,
                value: @inventory_category.id
              }
            else
              redirect_to erp_products.edit_backend_inventory_category_path(@inventory_category), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /inventory_categories/1
        def destroy
          @inventory_category.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_inventory_categories_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE /inventory_categories/archive?id=1
        def archive
          @inventory_category.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE /inventory_categories/archive?id=1
        def unarchive
          @inventory_category.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE ALL /inventory_categories/delete_all?ids=1,2,3
        def delete_all
          @inventory_categories.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE ALL /inventory_categories/archive_all?ids=1,2,3
        def archive_all
          @inventory_categories.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE ALL /inventory_categories/unarchive_all?ids=1,2,3
        def unarchive_all
          @inventory_categories.unarchive_all

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
              render json: InventoryCategory.dataselect(params[:keyword].strip)
            }
          end
        end

        # Move up /inventory_categories/up?id=1
        def move_up
          @inventory_category.move_up

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end
        end

        # Move down /inventory_categories/up?id=1
        def move_down
          @inventory_category.move_down

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
          def set_inventory_category
            @inventory_category = InventoryCategory.find(params[:id])
          end

          def set_inventory_categories
            @inventory_categories = InventoryCategory.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def inventory_category_params
            params.fetch(:inventory_category, {}).permit(:name, :hot_name)
          end
      end
    end
  end
end