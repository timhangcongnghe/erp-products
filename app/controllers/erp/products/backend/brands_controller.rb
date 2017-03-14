module Erp
  module Products
    module Backend
      class BrandsController < Erp::Backend::BackendController
        before_action :set_brand, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_brands, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /brands
        def index
        end
    
        # POST /brands/list
        def list
          @brands = Brand.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /brands/new
        def new
          @brand = Brand.new
        end
    
        # GET /brands/1/edit
        def edit
        end
    
        # POST /brands
        def create
          @brand = Brand.new(brand_params)
          @brand.creator = current_user
    
          if @brand.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @brand.name,
                value: @brand.id
              }
            else
              redirect_to erp_products.edit_backend_brand_path(@brand), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /brands/1
        def update
          if @brand.update(brand_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @brand.name,
                value: @brand.id
              }              
            else
              redirect_to erp_products.edit_backend_brand_path(@brand), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /brands/1
        def destroy
          @brand.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_brands_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /brands/archive?id=1
        def archive
          @brand.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /brands/archive?id=1
        def unarchive
          @brand.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /brands/delete_all?ids=1,2,3
        def delete_all         
          @brands.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /brands/archive_all?ids=1,2,3
        def archive_all         
          @brands.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /brands/unarchive_all?ids=1,2,3
        def unarchive_all
          @brands.unarchive_all
          
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
              render json: Brand.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_brand
            @brand = Brand.find(params[:id])
          end
          
          def set_brands
            @brands = Brand.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def brand_params
            params.fetch(:brand, {}).permit(:name, :description)
          end
      end
    end
  end
end
