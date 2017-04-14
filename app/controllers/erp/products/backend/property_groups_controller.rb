module Erp
  module Products
    module Backend
      class PropertyGroupsController < Erp::Backend::BackendController
        before_action :set_property_group, only: [:archive, :unarchive, :edit, :update, :destroy, :move_up, :move_down]
        before_action :set_property_groups, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /property_groups
        def index
        end

        # POST /property_groups/list
        def list
          @property_groups = PropertyGroup.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end

        # GET /property_groups/new
        def new
          @property_group = PropertyGroup.new
        end

        # GET /property_groups/1/edit
        def edit
        end

        # POST /property_groups
        def create
          @property_group = PropertyGroup.new(property_group_params)
          @property_group.creator = current_user

          if @property_group.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @property_group.name,
                value: @property_group.id
              }
            else
              redirect_to erp_products.edit_backend_property_group_path(@property_group), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /property_groups/1
        def update
          if @property_group.update(property_group_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @property_group.name,
                value: @property_group.id
              }
            else
              redirect_to erp_products.edit_backend_property_group_path(@property_group), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /property_groups/1
        def destroy
          @property_group.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_property_groups_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE /property_groups/archive?id=1
        def archive
          @property_group.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE /property_groups/archive?id=1
        def unarchive
          @property_group.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE ALL /property_groups/delete_all?ids=1,2,3
        def delete_all
          @property_groups.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE ALL /property_groups/archive_all?ids=1,2,3
        def archive_all
          @property_groups.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE ALL /property_groups/unarchive_all?ids=1,2,3
        def unarchive_all
          @property_groups.unarchive_all

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
              render json: PropertyGroup.dataselect(params[:keyword])
            }
          end
        end

        # Move up /property_groups/up?id=1
        def move_up
          @property_group.move_up

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        # Move down /property_groups/up?id=1
        def move_down
          @property_group.move_down

          respond_to do |format|
          format.json {
            render json: {
            }
          }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_property_group
            @property_group = PropertyGroup.find(params[:id])
          end

          def set_property_groups
            @property_groups = PropertyGroup.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def property_group_params
            params.fetch(:property_group, {}).permit(:name, :description)
          end
      end
    end
  end
end
