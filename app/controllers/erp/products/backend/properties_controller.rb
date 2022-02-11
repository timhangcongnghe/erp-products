module Erp
  module Products
    module Backend
      class PropertiesController < Erp::Backend::BackendController
        before_action :set_property, only: [:edit, :update, :destroy, :move_up, :move_down]
        
        def index
        end

        def list
          @properties = Property.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @property = Property.new
        end

        def edit
        end

        def create
          @property = Property.new(property_params)
          @property.creator = current_user
          if @property.save
            if request.xhr?
              render json: {status: 'success', text: @property.get_name, value: @property.id}
            else
              redirect_to erp_products.edit_backend_property_path(@property), notice: 'Tạo thuộc tính mới thành công!'
            end
          else
            render :new
          end
        end

        def update
          if @property.update(property_params)
            if request.xhr?
              render json: {status: 'success', text: @property.get_name, value: @property.id}
            else
              redirect_to erp_products.edit_backend_property_path(@property), notice: 'Cập nhật thuộc tính thành công!'
            end
          else
            render :edit
          end
        end

        def destroy
          @property.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_properties_path, notice: 'Xóa thuộc tính thành công!'}
            format.json {render json: {'message': 'Xóa thuộc tính thành công!', 'type': 'success'}}
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: Property.dataselect(params[:keyword])}
          end
        end

        def move_up
          @property.move_up
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        def move_down
          @property.move_down
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        private
          def set_property
            @property = Property.find(params[:id])
          end

          def set_properties
            @properties = Property.where(id: params[:ids])
          end

          def property_params
            params.fetch(:property, {}).permit(:is_meta_description, :is_short_description, :is_show_list, :is_show_detail, :is_show_website, :use_custom_sort, :name, :property_group_id)
          end
      end
    end
  end
end