require_dependency "erp/application_controller"

module Erp
  module Products
    module Backend
      class CategoriesController < Erp::Backend::BackendController
        before_action :set_category, only: [:edit, :update, :destroy]
        before_action :set_categories, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /categories
        def index
        end
        
        # POST /categories/list
        def list
          @categories = Category.search(params).paginate(:page => params[:page], :per_page => 3)
          
          render layout: nil
        end
    
        # GET /categories/new
        def new
          @category = Category.new
          
          if request.xhr?
            render '_form', layout: nil, locals: {category: @category}
          end
        end
    
        # GET /categories/1/edit
        def edit
        end
    
        # POST /categories
        def create
          @category = Category.new(category_params)
          @category.creator = current_user
          
          if @category.save
            if params.to_unsafe_hash['format'] == 'json'
              render json: {
                status: 'success',
                text: @category.name,
                value: @category.id
              }
            else
              redirect_to erp_products.edit_backend_category_path(@category), notice: 'Category was successfully created.'
            end
          else
            if params.to_unsafe_hash['format'] == 'json'
              render '_form', layout: nil, locals: {category: @category}
            else
              render :new
            end            
          end
        end
    
        # PATCH/PUT /categories/1
        def update
          if @category.update(category_params)
            redirect_to erp_products.edit_backend_category_path(@category), notice: 'Category was successfully updated.'
          else
            render :edit
          end
        end
    
        # DELETE /categories/1
        def destroy
          @category.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_categories_path, notice: 'Category was successfully destroyed.' }
            format.json {
              render json: {
                'message': 'Category was successfully destroyed.',
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE /categories/delete_all?ids=1,2,3
        def delete_all         
          @categories.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': 'Categories were successfully destroyed.',
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /categories/archive_all?ids=1,2,3
        def archive_all         
          @categories.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': 'Categories were successfully archived.',
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /categories/unarchive_all?ids=1,2,3
        def unarchive_all
          @categories.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': 'Categories were successfully active.',
                'type': 'success'
              }
            }
          end          
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: Category.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_category
            @category = Category.find(params[:id])
          end
          
          def set_categories
            @categories = Category.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def category_params
            params.fetch(:category, {}).permit(:name, :parent_id)
          end
      end
    end
  end
end
