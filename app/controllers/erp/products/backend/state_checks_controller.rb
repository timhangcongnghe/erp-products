module Erp
  module Products
    module Backend
      class StateChecksController < Erp::Backend::BackendController
        before_action :set_state_check, only: [:archive, :unarchive, :set_draft, :set_pending, :set_active, :set_deleted,
                                               :edit, :update, :show, :show_list, :pdf]
        before_action :set_state_checks, only: [:delete_all, :archive_all, :unarchive_all, :set_draft_all, :set_pending_all, :set_active_all, :set_deleted_all]

        # GET /state_checks
        def index
          authorize! :inventory_products_warehouse_checks_with_state_index, nil
        end

        # POST /state_checks/list
        def list
          authorize! :inventory_products_warehouse_checks_with_state_index, nil
          
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
        
        # GET /orders/1
        def pdf
          authorize! :print, @state_check

          respond_to do |format|
            format.html
            format.pdf do
              if @state_check.state_check_details.count < 8
                render pdf: "#{@state_check.code}",
                  title: "#{@state_check.code}",
                  layout: 'erp/backend/pdf',
                  page_size: 'A5',
                  orientation: 'Landscape',
                  margin: {
                    top: 7,                     # default 10 (mm)
                    bottom: 7,
                    left: 7,
                    right: 7
                  }
              else
                render pdf: "#{@state_check.code}",
                  title: "#{@state_check.code}",
                  layout: 'erp/backend/pdf',
                  page_size: 'A4',
                  margin: {
                    top: 7,                     # default 10 (mm)
                    bottom: 7,
                    left: 7,
                    right: 7
                  }
              end
            end
          end
        end

        # GET /state_checks/new
        def new
          @state_check = StateCheck.new
          @state_check.check_date = Time.now
          @state_check.employee_id = current_user.id
          
          authorize! :create, @state_check
        end

        # GET /state_checks/1/edit
        def edit
          authorize! :update, @state_check
        end

        # POST /state_checks
        def create
          @state_check = StateCheck.new(state_check_params)
          
          authorize! :create, @state_check
          
          @state_check.creator = current_user
          @state_check.set_pending

          if @state_check.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @state_check.name,
                value: @state_check.id
              }
            else
              redirect_to erp_products.backend_state_checks_path, notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /state_checks/1
        def update
          authorize! :update, @state_check
          
          if @state_check.update(state_check_params)
            
            # neu update thi phai duyet lai
            @state_check.set_pending if @state_check.is_active?
            
            if request.xhr?
              render json: {
                status: 'success',
                text: @state_check.name,
                value: @state_check.id
              }
            else
              redirect_to erp_products.backend_state_checks_path, notice: t('.success')
            end
          else
            render :edit
          end
        end

        ## DELETE /state_checks/1
        #def destroy
        #  @state_check.destroy
        #
        #  respond_to do |format|
        #    format.html { redirect_to erp_products.backend_state_checks_path, notice: t('.success') }
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

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

        # STATUS DRAFT /state_checks/set_draft?id=1
        def set_draft
          authorize! :set_draft, @state_check
          
          @state_check.set_draft
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS PENDING /state_checks/set_pending?id=1
        def set_pending
          authorize! :set_pending, @state_check
          
          @state_check.set_pending
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS ACTIVE /state_checks/set_active?id=1
        def set_active
          authorize! :set_active, @state_check
          
          @state_check.set_active
          @state_check.update_confirmed_at
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DELETED /state_checks/set_deleted?id=1
        def set_deleted
          authorize! :set_deleted, @state_check
          
          @state_check.set_deleted
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
        #def delete_all
        #  @state_checks.destroy_all
        #
        #  respond_to do |format|
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

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

        # STATUS DRAFT ALL /state_checks/set_draft_all?ids=1,2,3
        def set_draft_all
          @state_checks.set_draft_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS PENDING ALL /state_checks/set_pending_all?ids=1,2,3
        def set_pending_all
          @state_checks.set_pending_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS ACTIVE ALL /state_checks/set_active_all?ids=1,2,3
        def set_active_all
          @state_checks.set_active_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DELETED ALL /state_checks/set_deleted_all?ids=1,2,3
        def set_deleted_all
          @state_checks.set_deleted_all

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
                                                  :state_check_details_attributes => [:id, :product_id, :state_id, :old_state_id, :state_check_id, :note, :quantity, :_destroy])
          end
      end
    end
  end
end
