module Erp
  module Products
    module Backend
      class PropertiesController < Erp::Backend::BackendController
        before_action :set_property, only: [:archive, :unarchive, :edit, :update, :destroy]
        before_action :set_properties, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /properties
        def index
        end
    
        # POST /properties/list
        def list
          @properties = Property.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # GET /properties/new
        def new
          @property = Property.new
        end
    
        # GET /properties/1/edit
        def edit
        end
    
        # POST /properties
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
    
        # PATCH/PUT /properties/1
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
    
        # DELETE /properties/1
        def destroy
          @property.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_properties_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /properties/archive?id=1
        def archive
          @property.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /properties/archive?id=1
        def unarchive
          @property.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /properties/delete_all?ids=1,2,3
        def delete_all         
          @properties.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /properties/archive_all?ids=1,2,3
        def archive_all         
          @properties.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /properties/unarchive_all?ids=1,2,3
        def unarchive_all
          @properties.unarchive_all
          
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
              render json: Property.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_property
            @property = Property.find(params[:id])
          end
          
          def set_properties
            @properties = Property.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def property_params
            params.fetch(:property, {}).permit(:name, :property_group_id)
          end
      end
    end
  end
end