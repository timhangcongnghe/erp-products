require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class PriceListsController < Erp::Backend::BackendController
        before_action :set_price_list, only: [:enable, :disable, :show, :edit, :update, :destroy]
        before_action :set_price_lists, only: [:delete_all, :enable_all, :disable_all]
    
        # GET /price_lists
        def index
        end
        
        # POST /price_lists/list
        def list
          @price_lists = PriceList.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
        
        # GET /price_lists/1
        # GET /price_lists/1.json
        def show
          @products = Product.search(params).paginate(:page => params[:page], :per_page => 10)
        end
        
        # GET /price_lists/new
        def new
          @price_list = PriceList.new
          @price_list.valid_from = Time.now
          @price_list.valid_to = Time.now
          
          if request.xhr?
            render '_form', layout: nil, locals: {price_list: @price_list}
          end
        end
        
        # GET /price_lists/1/edit
        def edit
        end
    
        # POST /price_lists
        def create
          @price_list = PriceList.new(price_list_params)
          @price_list.creator = current_user
    
          if @price_list.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @price_list.name,
                value: @price_list.id
              }
            else
              redirect_to erp_products.edit_backend_price_list_path(@price_list), notice: t('.success')
            end
          else
            if params.to_unsafe_hash['format'] == 'json'
              render '_form', layout: nil, locals: {price_list: @price_list}
            else
              render :new
            end            
          end
        end
    
        # PATCH/PUT /price_lists/1
        def update
          if @price_list.update(price_list_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @price_list.name,
                value: price_list.id
              }
            else
              redirect_to erp_products.edit_backend_price_list_path(@price_list), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /price_lists/1
        def destroy
          @price_list.destroy
          respond_to do |format|
            format.html { redirect_to erp_products.backend_price_lists_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Inactive /price_lists/inactive?id=1
        def disable      
          @price_list.disable
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Active /price_lists/active?id=1
        def enable
          @price_list.enable
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # DELETE /price_lists/delete_all?ids=1,2,3
        def delete_all         
          @price_lists.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Inactive /price_lists/inactive_all?ids=1,2,3
        def disable_all         
          @price_lists.disable_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Active /price_lists/active_all?ids=1,2,3
        def enable_all
          @price_lists.enable_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Dataselect /price_lists/dataselect
        def dataselect
          respond_to do |format|
            format.json {
              render json: PriceList.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_price_list
            @price_list = PriceList.find(params[:id])
          end
          
          def set_price_lists
            @price_lists = PriceList.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def price_list_params
            params.fetch(:price_list, {}).permit(:name, :valid_from, :valid_to, :active,
                                                 :all_warehouses, :all_users, :all_contact_groups,
                                                 warehouse_ids: [], price_lists_user_ids: [])
          end
      end
    end
  end
end
