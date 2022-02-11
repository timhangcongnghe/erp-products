module Erp
  module Products
    module Backend
      class CategoriesController < Erp::Backend::BackendController
        before_action :set_category, only: [:archive, :unarchive, :edit, :update, :move_up, :move_down]
        before_action :set_categories, only: [:archive_all, :unarchive_all]

        def index
        end
        
        def list
          @categories = Category.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @category = Category.new
        end

        def edit
        end
        
        def create
          @category = Category.new(category_params)
          @category.creator = current_user
          if @category.save
            if request.xhr?
              render json: {status: 'success', text: @category.get_name, value: @category.id}
            else
              redirect_to erp_products.edit_backend_category_path(@category), notice: 'Tạo chuyên mục mới thành công!'
            end
          else
            render :new
          end
        end

        def update
          if @category.update(category_params)
            if request.xhr?
              render json: {status: 'success', text: @category.name, value: @category.id}
            else
              redirect_to erp_products.edit_backend_category_path(@category), notice: 'Cập nhật chuyên mục thành công!'
            end
          else
            render :edit
          end
        end

        def archive
          @category.archive
          respond_to do |format|
            format.json {render json: {'message': 'Ẩn chuyên mục thành công!', 'type': 'success'}}
          end
        end
        
        def unarchive
          @category.unarchive
          respond_to do |format|
            format.json {render json: {'message': 'Hiện chuyên mục thành công!', 'type': 'success'}}
          end
        end

        def archive_all
          @categories.archive_all
          respond_to do |format|
            format.json {render json: {'message': 'Ẩn chuyên mục được chọn thành công!', 'type': 'success'}}
          end
        end

        def unarchive_all
          @categories.unarchive_all
          respond_to do |format|
            format.json {render json: {'message': 'Hiện chuyên mục được chọn thành công!', 'type': 'success'}}
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: Category.dataselect(params[:keyword].split('/').last, params)}
          end
        end

        def move_up
          @category.move_up
          respond_to do |format|
            format.json {render json: {}}
          end
        end

        def move_down
          @category.move_down
          respond_to do |format|
            format.json {render json: {}}
          end
        end
        
        private
          def set_category
            @category = Category.find(params[:id])
          end
          
          def set_categories
            @categories = Category.where(id: params[:ids])
          end

          def category_params
            params.fetch(:category, {}).permit(:name, :parent_id, :unique_specs, :is_new_specs, :short_meta_description, property_group_ids: [])
          end
      end
    end
  end
end