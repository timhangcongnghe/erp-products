module Erp::Products
  class DamageRecord < ApplicationRecord
    validates :code, :date, :warehouse_id, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    
    has_many :damage_record_details, inverse_of: :damage_record, dependent: :destroy
    accepts_nested_attributes_for :damage_record_details, :reject_if => lambda { |a| a[:product_id].blank? || a[:quantity].blank? || a[:quantity].to_i <= 0 }
    if Erp::Core.available?("warehouses")
      belongs_to :warehouse, class_name: "Erp::Warehouses::Warehouse"
      def warehouse_name
        warehouse.present? ? warehouse.name : ''
      end
    end
    after_create  :set_drart
    
    # class const
    DAMAGE_RECORD_STATUS_PENDING = 'pending'
    DAMAGE_RECORD_STATUS_DONE = 'done'
    STATUS_DRAFT = 'draft'
    STATUS_DONE = 'done'
    STATUS_DELETED = 'deleted'
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      show_archived = false
      
      #filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            # in case filter is show archived
            if cond[1]["name"] == 'show_archived'
              show_archived = true
            else
              or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
            end
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end
      
      # show archived items condition - default: false
      show_archived = false
      
      #filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            # in case filter is show archived
            if cond[1]["name"] == 'show_archived'
              # show archived items
              show_archived = true
            else
              or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
            end
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # join with users table for search creator
      query = query.joins(:creator)
      
      # showing archived items if show_archived is not true
      query = query.where(archived: false) if show_archived == false
      
      # add conditions to query
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        
        query = query.order(order)
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|damage_record| {value: damage_record.id, text: damage_record.code} }
    end
    
    def creator_name
      creator.present? ? creator.name : ''
    end
    
    def archive
			update_attributes(archived: true)
		end
    
    def unarchive
			update_attributes(archived: false)
		end
    
    def self.archive_all
			update_all(archived: true)
		end
    
    def self.unarchive_all
			update_all(archived: false)
		end
    
    # damage record draft
    def set_drart
      self.update_columns(status: Erp::Products::DamageRecord::STATUS_DRAFT)
    end
    
    # damage record confirm
    def set_confirm
      self.update_columns(status: Erp::Products::DamageRecord::STATUS_DONE)
    end
    
    # damage record delete
    def set_delete
      self.update_columns(status: Erp::Products::DamageRecord::STATUS_DELETED)
    end
    
    # check if damage record is draft
		def is_draft?
			return self.status == Erp::Products::DamageRecord::STATUS_DRAFT
		end
    
    # check if damage record is done
		def is_done?
			return self.status == Erp::Products::DamageRecord::STATUS_DONE
		end
    
    # check if damage record is deleted
		def is_deleted?
			return self.status == Erp::Products::DamageRecord::STATUS_DELETED
		end
  end
end
