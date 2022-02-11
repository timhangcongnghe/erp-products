module Erp
  module Products
    module Backend
      class ProductsController < Erp::Backend::BackendController
        before_action :set_product, only: [:edit, :update, :copy, :update_alias, :destroy]
        before_action :set_products, only: [:hkerp_update_price, :delete_all, :archive, :unarchive, 
                                            :check_is_bestseller, :uncheck_is_bestseller, :check_is_call, :uncheck_is_call, :check_is_sold_out, :uncheck_is_sold_out]

        def index
        end

        def list
          @products = Product.search(params).paginate(page: params[:page], per_page: 20)
          render layout: nil
        end

        def new
          @product = Product.new
          20.times do
            @product.product_images.build
          end
          @product.deal_from_date = ''
          @product.deal_to_date = ''
          if params[:hkerp_id].present?
            @product.updateHkerpInfo(params[:hkerp_id])
          end
        end

        def edit
          (20 - @product.product_images.count).times do
            @product.product_images.build
          end
        end

        def create
          @product = Product.new(product_params)
          @product.creator = current_user
          20.times do
            @product.product_images.build
          end
          @product.product_property_values = params.to_unsafe_hash[:product_property_values]
          if params.to_unsafe_hash[:hkerp_id].present?
            @product.updateHkerpInfo(params.to_unsafe_hash[:hkerp_id])
          end
          if @product.save
            @product.update_products_values
            @product.hkerp_set_cache_thcn_properties
            if request.xhr?
              render json: {status: 'success', text: @product.get_name, value: @product.id}
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: 'Tạo sản phẩm mới thành công!'
            end
          else
            render :new
          end
        end

        def update
          @product.product_property_values = params.to_unsafe_hash[:product_property_values]
          @product.assign_attributes(product_params)
          if params.to_unsafe_hash[:hkerp_id].present?
            @product.updateHkerpInfo(params.to_unsafe_hash[:hkerp_id])
          end
          if @product.save
            @product.update_products_values
            @product.hkerp_set_cache_thcn_properties
            if params.to_unsafe_hash[:hkerp_id].present?
              if @product.hkerp_product.present?
                @product.hkerp_product.update(hkerp_product_id: params.to_unsafe_hash[:hkerp_id])
              else
                @product.hkerp_product.create({hkerp_product_id: params.to_unsafe_hash[:hkerp_id]})
              end
            else
              @product.hkerp_product.destroy if @product.hkerp_product.present?
            end
            if request.xhr?
              render json: {status: 'success', text: @product.get_name, value: @product.id}
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: 'Cập nhật sản phẩm thành công!'
            end
          else
            render :edit
          end
        end

        def copy
          @copied_product = @product.copy(creator: current_user)
          if request.xhr?
            render json: {status: 'product_copied_success', text: @copied_product.get_name, value: @copied_product.id, url: erp_products.edit_backend_product_path(@copied_product)}
          end
        end

        def update_alias
          @product.create_alias
          respond_to do |format|
            format.json {render json: {'status': 'product_alias_updated_success', 'message': 'Cập nhật alias thành công!', 'type': 'success'}}
          end
        end

        def archive
          @products.archive
          respond_to do |format|
            format.json {render json: {'message': 'Ẩn sản phẩm được chọn thành công!', 'type': 'success'}}
          end
        end

        def unarchive
          @products.unarchive
          respond_to do |format|
            format.json {render json: {'message': 'Hiện sản phẩm được chọn thành công!', 'type': 'success'}}
          end
        end

        def check_is_bestseller
          @products.check_is_bestseller
          respond_to do |format|
            format.json {render json: {'message': 'Thêm vào danh sách sản phẩm "Bán Chạy" thành công!', 'type': 'success'}}
          end
        end
        def uncheck_is_bestseller
          @products.uncheck_is_bestseller
          respond_to do |format|
            format.json {render json: {'message': 'Xóa khỏi danh sách sản phẩm "Bán Chạy" thành công!', 'type': 'success'}}
          end
        end

        def check_is_call
          @products.check_is_call
          respond_to do |format|
            format.json {render json: {'message': 'Thêm vào danh sách sản phẩm "Gọi Hỏi Hàng" thành công!', 'type': 'success'}}
          end
        end
        def uncheck_is_call
          @products.uncheck_is_call
          respond_to do |format|
            format.json {render json: {'message': 'Xóa khỏi danh sách sản phẩm "Gọi Hỏi Hàng" thành công!', 'type': 'success'}}
          end
        end

        def check_is_sold_out
          @products.check_is_sold_out
          respond_to do |format|
            format.json {render json: {'message': 'Thêm vào danh sách sản phẩm "Hết Hàng" thành công!', 'type': 'success'}}
          end
        end
        def uncheck_is_sold_out
          @products.uncheck_is_sold_out
          respond_to do |format|
            format.json {render json: {'message': 'Xóa khỏi danh sách sản phẩm "Hết Hàng" thành công!', 'type': 'success'}}
          end
        end

        def destroy
          @product.destroy
          respond_to do |format|
            format.html {redirect_to erp_products.backend_products_path, notice: 'Xóa sản phẩm thành công!'}
            format.json {render json: {'message': 'Xóa sản phẩm thành công!', 'type': 'success'}}
          end
        end

        def delete_all
          @products.destroy_all
          respond_to do |format|
            format.json {render json: {'message': 'Xóa sản phẩm được chọn thành công!', 'type': 'success'}}
          end
        end

        def dataselect
          respond_to do |format|
            format.json {render json: Product.dataselect(params[:keyword], params)}
          end
        end

        def hkerp_products
        end

        def hkerp_products_list
          url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_connector'
          uri = URI(url)
          res = Net::HTTP.post_form(uri, 'page' => params[:page].to_i-1, 'data' => params.to_unsafe_h.to_json)
          data = res.body
          @products = JSON.parse(data)
        end

        def hkerp_categories_dataselect
          url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_categories_dataselect'
          uri = URI(url)
          uri.query = URI.encode_www_form(params.to_unsafe_hash)
          res = Net::HTTP.get_response(uri)
          dataselect = res.body if res.is_a?(Net::HTTPSuccess)
          render json: dataselect
        end

        def hkerp_manufacturers_dataselect
          url = ErpSystem::Application.config.hkerp_endpoint + 'products/erp_manufacturers_dataselect'
          uri = URI(url)
          uri.query = URI.encode_www_form(params.to_unsafe_hash)
          res = Net::HTTP.get_response(uri)
          dataselect = res.body if res.is_a?(Net::HTTPSuccess)
          render json: dataselect
        end

        def hkerp_update_price
          @products.each do |p|
            p.updateHkerpInfo(p.hkerp_product.hkerp_product_id)
            p.save
            p.hkerp_update_price(true)
          end
          respond_to do |format|
            format.json {
              render json: {'message': 'Cập nhật giá bán thành công!', 'type': 'success'}}
          end
        end

        def property_form
          product = params[:id].present? ? Product.find(params[:id]) : Product.new
          product.category_id = params[:category_id]
          render partial: 'erp/products/backend/products/property_form', locals: {product: product}, layout: nil
        end

        def form_property
          render partial: params[:partial], locals: {products_values_attribute: {1 => {}}, uid: helpers.unique_id()}
        end

        private
          def set_product
            @product = Product.find(params[:id])
          end

          def set_products
            @products = Product.where(id: params[:ids])
          end

          def product_params
            params.fetch(:product, {}).permit(
              :code, :name, :can_be_sold, :can_be_purchased, :product_type, :barcode, :is_outside,
              :price, :cost, :on_hand, :weight, :volume, :is_for_pos, :unit_id,
              # frontend
              :specs, :is_deal, :is_stock_inventory, :deal_price, :deal_percent, :brand_id, :is_new, :accessory_id, :short_name, :product_intro_link,
              :deal_from_date, :deal_to_date, :meta_keywords, :is_bestseller, :is_business_choices, :is_top_business_choices, :is_sold_out, :is_call,
              :dimentions, :weights, :warranty, :datasheet, :alias, :custom_alias, :custom_title, :listed_price,
              # end frontend
              :stock_min, :stock_max, :description, :internal_note, :point_enabled, :category_id,
              customer_tax_ids: [], vendor_tax_ids: [],
              product_images_attributes: [:id, :image_url, :image_url_cache, :product_id, :_destroy],
              products_units_attributes: [:id, :unit_id, :conversion_value, :price, :code, :product_id, :_destroy],
              products_parts_attributes: [:id, :part_id, :quantity, :total, :product_id, :_destroy],
              products_gifts_attributes: [:id, :gift_id, :quantity, :price, :product_id, :_destroy]
            )
          end
      end
    end
  end
end