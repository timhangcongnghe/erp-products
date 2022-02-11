module Erp
  module Products
    module Backend
      class PropertiesValuesController < Erp::Backend::BackendController
        before_action :set_properties_value, only: [:edit, :update, :destroy, :move_up, :move_down, :export_products]

        def index
        end

        def list
          @properties_values = PropertiesValue.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @properties_value = PropertiesValue.new
        end

        def edit
        end

        def create
          @properties_value = PropertiesValue.new(properties_value_params)
          if @properties_value.save
            if request.xhr?
              render json: {status: 'success', text: @properties_value.get_value, value: @properties_value.id}
            else
              redirect_to erp_products.edit_backend_properties_value_path(@properties_value), notice: 'Tạo giá trị thuộc tính mới thành công!'
            end
          else
            render :new
          end
        end

        def update
          if @properties_value.update(properties_value_params)
            if request.xhr?
              render json: {status: 'success', text: @properties_value.get_value, value: @properties_value.id}
            else
              redirect_to erp_products.edit_backend_properties_value_path(@properties_value), notice: 'Cập nhật giá trị thuộc tính thành công!'
            end
          else
            render :edit
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: PropertiesValue.dataselect(params[:keyword], params)}
          end
        end

        def dataselect_for_menu
          respond_to do |format|
            format.json {render json: PropertiesValue.dataselect_for_menu(params[:keyword], params)}
          end
        end

        def destroy
          @properties_value.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_properties_values_path, notice: 'Xóa giá trị thuộc tính thành công!'}
            format.json {render json: {'message': 'Xóa giá trị thuộc tính thành công!', 'type': 'success'}}
          end
        end

        def move_up
          @properties_value.move_up
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        def move_down
          @properties_value.move_down
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        def export_products
          @products = @properties_value.products
          render helpers.export_partial, locals: {header: ['ID', 'PartNumber', 'Name', 'PropertyValue'], rows: (@products.map {|product| [product.id, product.code, product.name, @properties_value.value]})}
        end

        private
          def set_properties_value
            @properties_value = PropertiesValue.find(params[:id])
          end

          def properties_value_params
            params.fetch(:properties_value, {}).permit(:value, :property_id, :id_sort)
          end
      end
    end
  end
end