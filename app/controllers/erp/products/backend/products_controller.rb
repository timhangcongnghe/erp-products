module Erp
  module Products
    module Backend
      class ProductsController < Erp::Backend::BackendController
        before_action :set_product, only: [:check_is_business_choices, :uncheck_is_business_choices, :check_is_top_business_choices, :uncheck_is_top_business_choices,
                                           :check_is_sold_out, :uncheck_is_sold_out, :check_is_bestseller, :uncheck_is_bestseller,
                                           :check_is_stock_inventory, :uncheck_is_stock_inventory, :check_is_bestseller, :uncheck_is_bestseller,
                                           :archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_products, only: [:hkerp_update_price, :delete_all, :archive_all, :unarchive_all, :check_is_bestseller_all, :uncheck_is_bestseller_all,
                                            :check_is_sold_out_all, :uncheck_is_sold_out_all, :check_is_stock_inventory_all, :uncheck_is_stock_inventory_all,
                                            :check_is_business_choices_all, :uncheck_is_business_choices_all, :check_is_top_business_choices_all, :uncheck_is_top_business_choices_all]

        # GET /products
        def index
        end

        # POST /products/list
        def list
          @products = Product.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end

        # GET /products/1
        def show
        end

        # GET /products/new
        def new
          @product = Product.new
          8.times do
            @product.product_images.build
          end
          @product.deal_from_date = ''
          @product.deal_to_date = ''

          #@todo HK-ERP connector
          if params[:hkerp_id].present?
            @product.updateHkerpInfo(params[:hkerp_id])
          end
        end

        # GET /products/1/edit
        def edit
          # default product images
          (8 - @product.product_images.count).times do
            @product.product_images.build
          end
        end

        # POST /products
        def create
          @product = Product.new(product_params)
          @product.creator = current_user
          8.times do
            @product.product_images.build
          end
          @product.product_property_values = params.to_unsafe_hash[:product_property_values]

          #@todo HK-ERP connector
          if params.to_unsafe_hash[:hkerp_id].present?
            @product.updateHkerpInfo(params.to_unsafe_hash[:hkerp_id])
          end

          if @product.save
            @product.update_products_values

            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: t('.success')
            end
          else
            # default product images
            render :new
          end
        end

        # PATCH/PUT /products/1
        def update
          @product.product_property_values = params.to_unsafe_hash[:product_property_values]
          @product.assign_attributes(product_params)

          #@todo HK-ERP connector
            if params.to_unsafe_hash[:hkerp_id].present?
              @product.updateHkerpInfo(params.to_unsafe_hash[:hkerp_id])
            end

          if @product.save
            @product.update_products_values

            if request.xhr?
              render json: {
                status: 'success',
                text: @product.name,
                value: @product.id
              }
            else
              redirect_to erp_products.edit_backend_product_path(@product), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /products/1
        def destroy
          @product.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_products_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Archive /products/archive?id=1
        def archive
          @product.archive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Unarchive /products/unarchive?id=1
        def unarchive
          @product.unarchive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # DELETE /products/delete_all?ids=1,2,3
        def delete_all
          @products.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Archive /products/archive_all?ids=1,2,3
        def archive_all
          @products.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Unarchive /products/unarchive_all?ids=1,2,3
        def unarchive_all
          @products.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_bestseller /products/bestseller?id=1
        def check_is_bestseller
          @product.check_is_bestseller

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Uncheck_is_bestseller /products/bestseller?id=1
        def uncheck_is_bestseller
          @product.uncheck_is_bestseller

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Check_is_bestseller_all /products/bestseller?ids=1,2,3
        def check_is_bestseller_all
          @products.check_is_bestseller_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_bestseller_all /products/bestseller?ids=1,2,3
        def uncheck_is_bestseller_all
          @products.uncheck_is_bestseller_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_sold_out /products/sold_out?id=1
        def check_is_sold_out
          @product.check_is_sold_out

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Uncheck_is_sold_out /products/sold_out?id=1
        def uncheck_is_sold_out
          @product.uncheck_is_sold_out

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Check_is_sold_out_all /products/sold_out?ids=1,2,3
        def check_is_sold_out_all
          @products.check_is_sold_out_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_sold_out_all /products/sold_out?ids=1,2,3
        def uncheck_is_sold_out_all
          @products.uncheck_is_sold_out_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_stock_inventory /products/stock_inventory?id=1
        def check_is_stock_inventory
          @product.check_is_stock_inventory

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Uncheck_is_stock_inventory /products/stock_inventory?id=1
        def uncheck_is_stock_inventory
          @product.uncheck_is_stock_inventory

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Check_is_stock_inventory_all /products/stock_inventory?ids=1,2,3
        def check_is_stock_inventory_all
          @products.check_is_stock_inventory_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_stock_inventory_all /products/stock_inventory?ids=1,2,3
        def uncheck_is_stock_inventory_all
          @products.uncheck_is_stock_inventory_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_business_choices /products/business_choices?id=1
        def check_is_business_choices
          @product.check_is_business_choices

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Uncheck_is_business_choices /products/business_choices?id=1
        def uncheck_is_business_choices
          @product.uncheck_is_business_choices

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Check_is_business_choices_all /products/business_choices?ids=1,2,3
        def check_is_business_choices_all
          @products.check_is_business_choices_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_business_choices_all /products/business_choices?ids=1,2,3
        def uncheck_is_business_choices_all
          @products.uncheck_is_business_choices_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_top_business_choices /products/top_business_choices?id=1
        def check_is_top_business_choices
          @product.check_is_top_business_choices

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Uncheck_is_top_business_choices /products/top_business_choices?id=1
        def uncheck_is_top_business_choices
          @product.uncheck_is_top_business_choices

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Check_is_top_business_choices_all /products/top_business_choices?ids=1,2,3
        def check_is_top_business_choices_all
          @products.check_is_top_business_choices_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Check_is_top_business_choices_all /products/top_business_choices?ids=1,2,3
        def uncheck_is_top_business_choices_all
          @products.uncheck_is_top_business_choices_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        def dataselect
          respond_to do |format|
            format.json {
              render json: Product.dataselect(params[:keyword])
            }
          end
        end

        def form_property
          render partial: params[:partial], locals: { products_values_attribute: {1 => {}}, uid: helpers.unique_id() }
        end

        # get products from hkerp
        def hkerp_products

        end

        #@todo HK-ERP connector
        # Ajax list for hkerp products
        def hkerp_products_list
          url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_connector"

          uri = URI(url)
          res = Net::HTTP.post_form(uri, 'page' => params[:page].to_i-1, 'data' => params.to_unsafe_h.to_json)
          data = res.body
          @products = JSON.parse(data)

        end

        def hkerp_categories_dataselect
          url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_categories_dataselect"
          uri = URI(url)
          uri.query = URI.encode_www_form(params.to_unsafe_hash)

          res = Net::HTTP.get_response(uri)
          dataselect = res.body if res.is_a?(Net::HTTPSuccess)

          render json: dataselect
        end

        def hkerp_manufacturers_dataselect
          url = ErpSystem::Application.config.hkerp_endpoint + "products/erp_manufacturers_dataselect"
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
              render json: {
                'message': 'Price updated!',
                'type': 'success'
              }
            }
          end
        end
        ######################################

        def property_form
          product = params[:id].present? ? Product.find(params[:id]) : Product.new
          product.category_id = params[:category_id]

          render partial: 'erp/products/backend/products/property_form', locals: {product: product}, layout: nil
        end

        # Matrix report
        def matrix_report
        end

        def matrix_report_table
          if params.to_unsafe_hash[:global_filter].present? and params.to_unsafe_hash[:global_filter][:column].present?
            @columns = Erp::Products::ProductsValue.joins(:properties_value).where(
              erp_products_properties_values: {
                property_id: params.to_unsafe_hash[:global_filter][:column]
              }
            ).select(:value).map(&:value).uniq.sort
            @columns = (@columns.map {|v| v.to_i }).sort if !@columns.empty? and @columns[0] == @columns[0].to_i.to_s
          end

          if params.to_unsafe_hash[:global_filter].present? and params.to_unsafe_hash[:global_filter][:row].present?
            @rows = Erp::Products::ProductsValue.joins(:properties_value).where(
              erp_products_properties_values: {
                property_id: params.to_unsafe_hash[:global_filter][:row]
              }
            ).select(:value).map(&:value).uniq.sort
            @rows = (@rows.map {|v| v.to_i }).sort if !@rows.empty? and @rows[0] == @rows[0].to_i.to_s
          end

          render layout: nil
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_product
            @product = Product.find(params[:id])
          end

          def set_products
            @products = Product.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def product_params
            params.fetch(:product, {}).permit(
              :code, :name, :can_be_sold, :can_be_purchased, :product_type, :barcode,
              :price, :cost, :on_hand, :weight, :volume, :is_for_pos, :unit_id,
              # frontend
              :is_deal, :is_stock_inventory, :deal_price, :deal_percent, :short_description, :brand_id, :is_new, :accessory_id, :short_name, :product_intro_link,
              :deal_from_date, :deal_to_date, :meta_keywords, :meta_description, :is_bestseller, :is_business_choices, :is_top_business_choices, :is_sold_out,
              # end frontend
              :stock_min, :stock_max, :description, :internal_note, :point_enabled, :category_id,
              customer_tax_ids: [], vendor_tax_ids: [],
              :product_images_attributes => [ :id, :image_url, :image_url_cache, :product_id, :_destroy ],
              :products_units_attributes => [ :id, :unit_id, :conversion_value, :price, :code, :product_id, :_destroy ],
              :products_parts_attributes => [ :id, :part_id, :quantity, :total, :product_id, :_destroy ],
              :products_gifts_attributes => [ :id, :gift_id, :quantity, :price, :product_id, :_destroy ]
              )
          end
      end
    end
  end
end
