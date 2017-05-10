module Erp
  module Products
    module Backend
      class RatingsController < Erp::Backend::BackendController
        before_action :set_rating, only: [:archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_ratings, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /ratings
        def list
          @ratings = Rating.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
    
        # DELETE /ratings/1
        def destroy
          @rating.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_ratings_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE /comments/delete_all?ids=1,2,3
        def delete_all         
          @ratings.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /comments/archive?id=1
        def archive      
          @rating.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Unarchive /comments/unarchive?id=1
        def unarchive
          @rating.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        
        # Archive /comments/archive_all?ids=1,2,3
        def archive_all         
          @ratings.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /comments/unarchive_all?ids=1,2,3
        def unarchive_all
          @ratings.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_rating
            @rating = Rating.find(params[:id])
          end
          
          def set_ratings
            @ratings = Rating.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def rating_params
            params.fetch(:rating, {})
          end
      end
    end
  end
end
