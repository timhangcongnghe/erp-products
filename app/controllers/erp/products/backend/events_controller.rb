module Erp
  module Products
    module Backend
      class EventsController < Erp::Backend::BackendController
        before_action :set_event, only: [:archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_events, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /events
        def index
        end
        
        # GET /events
        def list
          @events = Event.search(params).paginate(:page => params[:page], :per_page => 10)

          render layout: nil
        end
    
        # GET /events/1
        def show
        end
    
        # GET /events/new
        def new
          @event = Event.new
          
          if request.xhr?
            render '_form', layout: nil, locals: {event: @event}
          end
        end
    
        # GET /events/1/edit
        def edit
        end
    
        # POST /events
        def create
          @event = Event.new(event_params)
          @event.creator = current_user
    
          if @event.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @event.name,
                value: @event.id
              }
            else
              redirect_to erp_products.edit_backend_event_path(@event), notice: t('.success')
            end
          else
            if request.xhr?
              render '_form', layout: nil, locals: {event: @event}
            else
              render :new
            end
          end
        end
    
        # PATCH/PUT /events/1
        def update
          if @event.update(event_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @event.id,
                value: @event.name
              }              
            else
              redirect_to erp_products.edit_backend_event_path(@event), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /events/1
        def destroy
          @event.destroy
          respond_to do |format|
            format.html { redirect_to erp_products.backend_vents_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE /events/delete_all?ids=1,2,3
        def delete_all         
          @events.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /events/archive?id=1
        def archive      
          @event.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Unarchive /events/unarchive?id=1
        def unarchive
          @event.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end          
        end
        
        # Archive /events/archive_all?ids=1,2,3
        def archive_all         
          @events.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /events/unarchive_all?ids=1,2,3
        def unarchive_all
          @events.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # dataselect /events
        def dataselect
          respond_to do |format|
            format.json {
              render json: Event.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_event
            @event = Event.find(params[:id])
          end
          
          def set_events
            @events = Event.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def event_params
            params.fetch(:event, {}).permit(:name, :from_date, :to_date, :image_url, :description,
                                            :events_products_attributes => [:id, :event_id, :product_id, :_destroy])
          end
      end
    end
  end
end
