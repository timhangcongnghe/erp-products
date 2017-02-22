require_dependency "erp/backend/backend_controller"

module Erp
  module Products
    module Backend
      class DamageRecordsController < Erp::Backend::BackendController
        before_action :set_damage_record, only: [:damage_record_confirm, :archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_damage_records, only: [:delete_all, :archive_all, :unarchive_all]
        
        # GET /damage_records
        def index
        end
        
        # POST /damage_records/list
        def list
          @damage_records = DamageRecord.search(params).paginate(:page => params[:page], :per_page => 3)
          
          render layout: nil
        end
    
        # GET /damage_records/1
        def show
        end
    
        # GET /damage_records/new
        def new
          @damage_record = DamageRecord.new
          @damage_record.date = Time.now
        end
    
        # GET /damage_records/1/edit
        def edit
        end
    
        # POST /damage_records
        def create
          @damage_record = DamageRecord.new(damage_record_params)
          @damage_record.creator = current_user
    
          if @damage_record.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @damage_record.code,
                value: @damage_record.id
              }
            else
              redirect_to erp_products.edit_backend_damage_record_path(@damage_record), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /damage_records/1
        def update
          if @damage_record.update(damage_record_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @damage_record.code,
                value: @damage_record.id
              }              
            else
              redirect_to erp_products.edit_backend_damage_record_path(@damage_record), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /damage_records/1
        def destroy
          @damage_record.destroy

          respond_to do |format|
            format.html { redirect_to erp_products.backend_damage_records_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
         
        # Archive /damage_records/archive?id=1
        def archive
          @damage_record.archive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end 
        end
        
        # Unarchive /damage_records/unarchive?id=1
        def unarchive
          @damage_record.unarchive
          
          respond_to do |format|
          format.json {
            render json: {
            'message': t('.success'),
            'type': 'success'
            }
          }
          end
        end
        
        # DELETE /damage_records/delete_all?ids=1,2,3
        def delete_all         
          @damage_records.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Archive /damage_records/archive_all?ids=1,2,3
        def archive_all         
          @damage_records.archive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Unarchive /damage_records/unarchive_all?ids=1,2,3
        def unarchive_all
          @damage_records.unarchive_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # Confirm /damage_records/damage_record_confirm?id=1
        def damage_record_confirm
          @damage_record.damage_record_confirm
          
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
              render json: DamageRecord.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_damage_record
            @damage_record = DamageRecord.find(params[:id])
          end
          
          def set_damage_records
            @damage_records = DamageRecord.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def damage_record_params
            params.fetch(:damage_record, {}).permit(:code, :date, :warehouse_id, :description,
                                            :damage_record_details_attributes => [ :id, :product_id, :damage_record_id, :quantity, :note, :_destroy ])
          end
      end
    end
  end
end