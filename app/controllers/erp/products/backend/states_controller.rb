module Erp
  module Products
    module Backend
      class StatesController < Erp::Backend::BackendController
        before_action :set_state, only: [:archive, :unarchive, :set_draft, :set_active, :set_deleted, :edit, :update]
        before_action :set_states, only: [:delete_all, :archive_all, :unarchive_all, :set_draft_all, :set_active_all, :set_deleted_all]

        # GET /states
        def index
          authorize! :inventory_products_states_index, nil
        end

        # POST /states/list
        def list
          authorize! :inventory_products_states_index, nil
          
          @states = State.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end

        # GET /states/new
        def new
          @state = State.new
          
          authorize! :create, @state
        end

        # GET /states/1/edit
        def edit
          authorize! :update, @state
        end

        # POST /states
        def create
          @state = State.new(state_params)
          
          authorize! :create, @state
          
          @state.creator = current_user
          @state.set_active

          if @state.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @state.name,
                value: @state.id
              }
            else
              redirect_to erp_products.backend_states_path, notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /states/1
        def update
          authorize! :update, @state
          
          if @state.update(state_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @state.name,
                value: @state.id
              }
            else
              redirect_to erp_products.backend_states_path, notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /states/1
        #def destroy
        #  @state.destroy
        #
        #  respond_to do |format|
        #    format.html { redirect_to erp_products.backend_states_path, notice: t('.success') }
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

        # ARCHIVE /states/archive?id=1
        def archive
          @state.archive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE /states/archive?id=1
        def unarchive
          @state.unarchive
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DRAFT /states/set_draft?id=1
        def set_draft
          authorize! :set_draft, @state
          
          @state.set_draft
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS ACTIVE /states/set_active?id=1
        def set_active
          authorize! :set_active, @state
          
          @state.set_active
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DELETED /states/set_deleted?id=1
        def set_deleted
          authorize! :set_deleted, @state
          
          @state.set_deleted
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE ALL /states/delete_all?ids=1,2,3
        def delete_all
          @states.destroy_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # ARCHIVE ALL /states/archive_all?ids=1,2,3
        def archive_all
          @states.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # UNARCHIVE ALL /states/unarchive_all?ids=1,2,3
        def unarchive_all
          @states.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DRAFT ALL /states/set_draft_all?ids=1,2,3
        def set_draft_all
          @states.set_draft_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS ACTIVE ALL /states/set_active_all?ids=1,2,3
        def set_active_all
          @states.set_active_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # STATUS DELETED ALL /states/set_deleted_all?ids=1,2,3
        def set_deleted_all
          @states.set_deleted_all

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
              render json: State.dataselect(params[:keyword], params)
            }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_state
            @state = State.find(params[:id])
          end

          def set_states
            @states = State.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def state_params
            params.fetch(:state, {}).permit(:name, :description)
          end
      end
    end
  end
end
