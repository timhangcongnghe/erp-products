module Erp
  module Products
    module Backend
      class BrandsController < Erp::Backend::BackendController
        before_action :set_brand, only: [:edit, :update, :destroy]
    
        def index
        end

        def list
          @brands = Brand.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end
    
        def new
          @brand = Brand.new
        end

        def edit
        end
    
        def create
          @brand = Brand.new(brand_params)
          @brand.creator = current_user
          if @brand.save
            if request.xhr?
              render json: {status: 'success', text: @brand.get_name, value: @brand.id}
            else
              redirect_to erp_products.edit_backend_brand_path(@brand), notice: 'Tạo thương hiệu mới thành công!'
            end
          else
            render :new        
          end
        end

        def update
          if @brand.update(brand_params)
            if request.xhr?
              render json: {status: 'success', text: @brand.get_name, value: @brand.id}              
            else
              redirect_to erp_products.edit_backend_brand_path(@brand), notice: 'Cập nhật thương hiệu thành công!'
            end
          else
            render :edit
          end
        end

        def destroy
          @brand.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_brands_path, notice: 'Xóa thương hiệu thành công!'}
            format.json {render json: {'message': 'Xóa thương hiệu thành công!', 'type': 'success'}}
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: Brand.dataselect(params[:keyword])}
          end
        end
    
        private
          def set_brand
            @brand = Brand.find(params[:id])
          end
          
          def set_brands
            @brands = Brand.where(id: params[:ids])
          end

          def brand_params
            params.fetch(:brand, {}).permit(:image_url, :name, :description, :is_main)
          end
      end
    end
  end
end