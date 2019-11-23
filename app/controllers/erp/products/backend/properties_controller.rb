module Erp
  module Products
    module Backend
      class PropertiesController < Erp::Backend::BackendController
        before_action :set_property, only: [:archive, :unarchive, :edit, :update, :destroy, :move_up, :move_down]
        before_action :set_properties, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /properties
        def index
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_properties_index, nil
          end
        end

        # POST /properties/list
        def list
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_properties_index, nil
          end
          
          @properties = Property.search(params).paginate(:page => params[:page], :per_page => 20)

          render layout: nil
        end

        # GET /properties/new
        def new
          @property = Property.new
          
          authorize! :create, @property
        end

        # GET /properties/1/edit
        def edit
          authorize! :update, @property
        end

        # POST /properties
        def create
          @property = Property.new(property_params)
          
          authorize! :create, @property
          
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
          authorize! :update, @property
          
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
          authorize! :destroy, @property
          
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

        # Move up /properties/up?id=1
        def move_up
          @property.move_up

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        # Move down /properties/up?id=1
        def move_down
          @property.move_down

          respond_to do |format|
          format.json {
            render json: {
            }
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
            params.fetch(:property, {}).permit(:is_meta_description, :is_show_list, :is_show_detail,
                                               :is_show_website, :name, :property_group_id)
          end
      end
    end
  end
end
