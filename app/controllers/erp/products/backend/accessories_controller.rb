module Erp
  module Products
    module Backend
      class AccessoriesController < Erp::Backend::BackendController
        before_action :set_accessory, only: [:archive, :unarchive, :edit, :update, :destroy]

        def index
        end
    
        def list
          @accessories = Accessory.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @accessory = Accessory.new
        end

        def edit
        end

        def create
          @accessory = Accessory.new(accessory_params)
          @accessory.creator = current_user
          if @accessory.save
            if request.xhr?
              render json: {status: 'success', text: @accessory.get_name, value: @accessory.id}
            else
              redirect_to erp_products.edit_backend_accessory_path(@accessory), notice: 'Tạo nhóm phụ kiện mới thành công!'
            end
          else
            render :new        
          end
        end

        def update
          if @accessory.update(accessory_params)
            if request.xhr?
              render json: {status: 'success',text: @accessory.get_name, value: @accessory.id}              
            else
              redirect_to erp_products.edit_backend_accessory_path(@accessory), notice: 'Cập nhật nhóm phụ kiện thành công!'
            end
          else
            render :edit
          end
        end

        def destroy
          @accessory.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_accessories_path, notice: 'Xóa nhóm phụ kiện thành công!'}
            format.json {render json: {'message': 'Xóa nhóm phụ kiện thành công!', 'type': 'success'}}
          end
        end

        def archive
          @accessory.archive
          respond_to do |format|
            format.json {render json: {'message': 'Ẩn nhóm phụ kiện thành công!','type': 'success'}}
          end
        end
        
        def unarchive
          @accessory.unarchive
          respond_to do |format|
            format.json {render json: {'message': 'Hiện nhóm phụ kiện thành công!', 'type': 'success'}}
          end
        end
        
        def dataselect
          respond_to do |format|
            format.json {render json: Accessory.dataselect(params[:keyword])}
          end
        end
    
        private
          def set_accessory
            @accessory = Accessory.find(params[:id])
          end

          def accessory_params
            params.fetch(:accessory, {}).permit(:name, :description, accessory_details_attributes: [:id, :product_id, :_destroy])
          end
      end
    end
  end
end
