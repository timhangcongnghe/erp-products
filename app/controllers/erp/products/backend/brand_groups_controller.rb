module Erp
  module Products
    module Backend
      class BrandGroupsController < Erp::Backend::BackendController
        before_action :set_brand_group, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_brand_groups, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /brand_groups
        def index
        end
    
        # POST /brand_groups/list
        def list
          @brand_groups = BrandGroup.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /brand_groups/new
        def new
          @brand_group = BrandGroup.new
        end
    
        # GET /brand_groups/1/edit
        def edit
        end
    
        # POST /brand_groups
        def create
          @brand_group = BrandGroup.new(brand_group_params)
          @brand_group.creator = current_user
    
          if @brand_group.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @brand_group.name,
                value: @brand_group.id
              }
            else
              redirect_to erp_products.edit_backend_brand_group_path(@brand_group), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /brand_groups/1
        def update
          if @brand_group.update(brand_group_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @brand_group.name,
                value: @brand_group.id
              }              
            else
              redirect_to erp_products.edit_backend_brand_group_path(@brand_group), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /brand_groups/1
        def destroy
          @brand_group.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_brand_groups_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /brand_groups/archive?id=1
        def archive
          @brand_group.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /brand_groups/archive?id=1
        def unarchive
          @brand_group.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /brand_groups/delete_all?ids=1,2,3
        def delete_all         
          @brand_groups.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /brand_groups/archive_all?ids=1,2,3
        def archive_all         
          @brand_groups.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /brand_groups/unarchive_all?ids=1,2,3
        def unarchive_all
          @brand_groups.unarchive_all
          
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
              render json: BrandGroup.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_brand_group
            @brand_group = BrandGroup.find(params[:id])
          end
          
          def set_brand_groups
            @brand_groups = BrandGroup.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def brand_group_params
            params.fetch(:brand_group, {}).permit(:name, :description,
                                                  :brand_group_details_attributes => [:id, :brand_id, :_destroy])
          end
      end
    end
  end
end
