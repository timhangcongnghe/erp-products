module Erp
  module Products
    module Backend
      class AccessoriesController < Erp::Backend::BackendController
        before_action :set_accessory, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_accessories, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /accessories
        def index
        end
    
        # POST /accessories/list
        def list
          @accessories = Accessory.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /accessories/new
        def new
          @accessory = Accessory.new
        end
    
        # GET /accessories/1/edit
        def edit
        end
    
        # POST /accessories
        def create
          @accessory = Accessory.new(accessory_params)
          @accessory.creator = current_user
    
          if @accessory.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @accessory.name,
                value: @accessory.id
              }
            else
              redirect_to erp_products.edit_backend_accessory_path(@accessory), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /accessories/1
        def update
          if @accessory.update(accessory_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @accessory.name,
                value: @accessory.id
              }              
            else
              redirect_to erp_products.edit_backend_accessory_path(@accessory), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /accessories/1
        def destroy
          @accessory.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_accessories_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /accessories/archive?id=1
        def archive
          @accessory.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /accessories/archive?id=1
        def unarchive
          @accessory.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /accessories/delete_all?ids=1,2,3
        def delete_all         
          @accessories.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /accessories/archive_all?ids=1,2,3
        def archive_all         
          @accessories.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /accessories/unarchive_all?ids=1,2,3
        def unarchive_all
          @accessories.unarchive_all
          
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
              render json: Accessory.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_accessory
            @accessory = Accessory.find(params[:id])
          end
          
          def set_accessories
            @accessories = Accessory.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def accessory_params
            params.fetch(:accessory, {}).permit(:name, :description,
                                                  :accessory_details_attributes => [:id, :product_id, :_destroy])
          end
      end
    end
  end
end
