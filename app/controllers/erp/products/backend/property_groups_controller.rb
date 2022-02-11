module Erp
  module Products
    module Backend
      class PropertyGroupsController < Erp::Backend::BackendController
        before_action :set_property_group, only: [:edit, :update, :destroy, :move_up, :move_down]

        def index
        end

        def list
          @property_groups = PropertyGroup.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @property_group = PropertyGroup.new
        end

        def edit
        end

        def create
          @property_group = PropertyGroup.new(property_group_params)
          @property_group.creator = current_user
          if @property_group.save
            if request.xhr?
              render json: {status: 'success', text: @property_group.get_name, value: @property_group.id}
            else
              redirect_to erp_products.edit_backend_property_group_path(@property_group), notice: 'Tạo nhóm thuộc tính mới thành công!'
            end
          else
            render :new
          end
        end

        def update
          if @property_group.update(property_group_params)
            if request.xhr?
              render json: {status: 'success', text: @property_group.get_name, value: @property_group.id}
            else
              redirect_to erp_products.edit_backend_property_group_path(@property_group), notice: 'Cập nhật nhóm thuộc tính thành công!'
            end
          else
            render :edit
          end
        end

        def destroy
          @property_group.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_property_groups_path, notice: 'Xóa nhóm thuộc tính thành công!'}
            format.json {render json: {'message': 'Xóa nhóm thuộc tính thành công!','type': 'success'}}
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: PropertyGroup.dataselect(params[:keyword])}
          end
        end

        def move_up
          @property_group.move_up
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        def move_down
          @property_group.move_down
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        private
          def set_property_group
            @property_group = PropertyGroup.find(params[:id])
          end

          def set_property_groups
            @property_groups = PropertyGroup.where(id: params[:ids])
          end

          def property_group_params
            params.fetch(:property_group, {}).permit(:name, :show_name, :is_filter_specs)
          end
      end
    end
  end
end