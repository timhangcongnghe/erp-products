module Erp
  module Products
    module Backend
      class StateChecksController < Erp::Backend::BackendController
        before_action :set_state_check, only: [:archive, :unarchive, :status_draft, :status_active, :status_deleted, :edit, :update, :destroy]
        before_action :set_state_checks, only: [:delete_all, :archive_all, :unarchive_all, :status_draft_all, :status_active_all, :status_deleted_all]
    
        # GET /state_checks
        def index
        end
    
        # POST /state_checks/list
        def list
          @state_checks = StateCheck.search(params).paginate(:page => params[:page], :per_page => 10)
          if params.to_unsafe_hash[:global_filter].present? and params.to_unsafe_hash[:global_filter][:state_check_date].present?
            @state_checks = @state_checks.where('check_date >= ?', params.to_unsafe_hash[:global_filter][:state_check_date].to_date.beginning_of_day)
          end
          render layout: nil
        end
        
        def state_check_details
          @state_check = StateCheck.find(params[:id])
          
          render layout: nil
        end
    
        # GET /state_checks/new
        def new
          @state_check = StateCheck.new
          @state_check.check_date = Time.now
        end
    
        # GET /state_checks/1/edit
        def edit
        end
    
        # POST /state_checks
        def create
          @state_check = StateCheck.new(state_check_params)
          @state_check.creator = current_user
    
          if @state_check.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @state_check.name,
                value: @state_check.id
              }
            else
              redirect_to erp_products.edit_backend_state_check_path(@state_check), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /state_checks/1
        def update
          if @state_check.update(state_check_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @state_check.name,
                value: @state_check.id
              }              
            else
              redirect_to erp_products.edit_backend_state_check_path(@state_check), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /state_checks/1
        def destroy
          @state_check.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_state_checks_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # ARCHIVE /state_checks/archive?id=1
        def archive
          @state_check.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # UNARCHIVE /state_checks/archive?id=1
        def unarchive
          @state_check.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # STATUS DRAFT /state_checks/status_draft?id=1
        def status_draft
          @state_check.status_draft
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # STATUS ACTIVE /state_checks/status_active?id=1
        def status_active
          @state_check.status_active
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # STATUS DELETED /state_checks/status_deleted?id=1
        def status_deleted
          @state_check.status_deleted
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /state_checks/delete_all?ids=1,2,3
        def delete_all         
          @state_checks.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # ARCHIVE ALL /state_checks/archive_all?ids=1,2,3
        def archive_all         
          @state_checks.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # UNARCHIVE ALL /state_checks/unarchive_all?ids=1,2,3
        def unarchive_all
          @state_checks.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # STATUS DRAFT ALL /state_checks/status_draft_all?ids=1,2,3
        def status_draft_all         
          @state_checks.status_draft_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # STATUS ACTIVE ALL /state_checks/status_active_all?ids=1,2,3
        def status_active_all
          @state_checks.status_active_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # STATUS DELETED ALL /state_checks/status_deleted_all?ids=1,2,3
        def status_deleted_all
          @state_checks.status_deleted_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: StateCheck.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_state_check
            @state_check = StateCheck.find(params[:id])
          end
          
          def set_state_checks
            @state_checks = StateCheck.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def state_check_params
            params.fetch(:state_check, {}).permit(:name, :check_date, :warehouse_id, :employee_id, :note,
                                                  :state_check_details_attributes => [:id, :product_id, :state_id, :state_check_id, :note, :quantity, :_destroy])
          end
      end
    end
  end
end