module Erp::Products
  class State < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    STATE_STATUS_DRAFT = 'draft'
    STATE_STATUS_ACTIVE = 'active'
    STATE_STATUS_DELETED = 'deleted'
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
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
        query = query.where('LOWER(code) LIKE ?', "%#{keyword}%")
      end
      
      query = query.limit(8).map{|state| {value: state.id, text: state.name} }
    end
    
    def creator_name
      creator.present? ? creator.name : ''
    end
    
    # STATUS
    def status_draft
			update_attributes(status: Erp::Products::State::STATE_STATUS_DRAFT)
		end
    
    def status_active
			update_attributes(status: Erp::Products::State::STATE_STATUS_ACTIVE)
		end
    
    def status_deleted
			update_attributes(status: Erp::Products::State::STATE_STATUS_DELETED)
		end
    
    def self.status_draft_all
			update_all(status: Erp::Products::State::STATE_STATUS_DRAFT)
		end
    
    def self.status_active_all
			update_all(status: Erp::Products::State::STATE_STATUS_ACTIVE)
		end
    
    def self.status_deleted_all
			update_all(status: Erp::Products::State::STATE_STATUS_DELETED)
		end
    
    # ARCHIVE
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
  end
end
