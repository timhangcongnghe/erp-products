module Erp
  module Products
    module Backend
      class CommentsController < Erp::Backend::BackendController
        before_action :set_comment, only: [:archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_comments, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /comments
        def list
          @comments = Comment.search(params).paginate(:page => params[:page], :per_page => 10)
          
          render layout: nil
        end
        
        def children_comments
          @comment = Erp::Products::Comment.find(params[:id])
          
          render layout: nil
        end
    
        # DELETE /comments/1
        def destroy
          @comment.destroy
          
          respond_to do |format|
            format.html { redirect_to erp_products.backend_comments_path, notice: t('.success') }
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
          @comments.destroy_all
          
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
          @comment.archive
          
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
          @comment.unarchive
          
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
          @comments.archive_all
          
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
          @comments.unarchive_all
          
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
              render json: Comment.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_comment
            @comment = Comment.find(params[:id])
          end
          
          def set_comments
            @comments = Comment.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def comment_params
            params.fetch(:comment, {}).permit(:name, :message, :product_id)
          end
      end
    end
  end
end
