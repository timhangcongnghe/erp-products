module Erp
  module Products
    module Backend
      class CategoriesController < Erp::Backend::BackendController
        before_action :set_category, only: [:archive, :unarchive, :edit, :update, :move_up, :move_down]
        before_action :set_categories, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /categories
        def index
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_categories_index, nil
          end
        end

        # POST /categories/list
        def list
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_categories_index, nil
          end
          
          @categories = Category.search(params).paginate(:page => params[:page], :per_page => 50)

          render layout: nil
        end

        # GET /categories/new
        def new
          @category = Category.new
          
          authorize! :create, @category

          if request.xhr?
            render '_form', layout: nil, locals: {category: @category}
          end
        end

        # GET /categories/1/edit
        def edit
          authorize! :update, @category
        end

        # POST /categories
        def create
          @category = Category.new(category_params)
          
          authorize! :create, @category
          
          @category.creator = current_user

          if @category.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @category.name,
                value: @category.id
              }
            else
              redirect_to erp_products.edit_backend_category_path(@category), notice: t('.success')
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
          authorize! :create, @category
          
          if @category.update(category_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @category.name,
                value: @category.id
              }
            else
              redirect_to erp_products.edit_backend_category_path(@category), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /categories/1
        #def destroy
        #  @category.destroy
        #
        #  respond_to do |format|
        #    format.html { redirect_to erp_products.backend_categories_path, notice: t('.success') }
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

        # Archive /categories/archive?id=1
        def archive
          authorize! :archive, @category
          
          @category.archive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end

        # Unarchive /categories/unarchive?id=1
        def unarchive
          authorize! :unarchive, @category
          
          @category.unarchive

          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
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
                'message': t('.success'),
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
                'message': t('.success'),
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
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        def dataselect
          respond_to do |format|
            format.json {
              render json: Category.dataselect(params[:keyword].split('/').last.to_s.strip, params)
            }
          end
        end

        # Move up /categories/up?id=1
        def move_up
          @category.move_up

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
          }
          end
        end

        # Move down /categories/up?id=1
        def move_down
          @category.move_down

          respond_to do |format|
          format.json {
            render json: {
            #'message': t('.success'),
            #'type': 'success'
            }
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
            params.fetch(:category, {}).permit(:name, :parent_id, property_group_ids: [])
          end
      end
    end
  end
end
