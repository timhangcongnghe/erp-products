module Erp::Products
  class State < ApplicationRecord
    validates :name, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    STATUS_DRAFT = 'draft'
    STATUS_ACTIVE = 'active'
    STATUS_DELETED = 'deleted'

    # get all active
    def self.all_active
      self.where(status: State::STATUS_ACTIVE)
    end

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
    def self.dataselect(keyword='', params={})
      query = self.all_active

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      if params[:current_value].present?
        query = query.where.not(id: params[:current_value].split(','))
      end

      query = query.limit(8).map{|state| {value: state.id, text: state.name} }
    end

    def creator_name
      creator.present? ? creator.name : ''
    end

    # STATUS
    def set_draft
			update_attributes(status: Erp::Products::State::STATUS_DRAFT)
		end

    def set_active
			update_attributes(status: Erp::Products::State::STATUS_ACTIVE)
		end

    def set_deleted
			update_attributes(status: Erp::Products::State::STATUS_DELETED)
		end

    def self.set_draft_all
			update_all(status: Erp::Products::State::STATUS_DRAFT)
		end

    def self.set_active_all
			update_all(status: Erp::Products::State::STATUS_ACTIVE)
		end

    def self.set_deleted_all
			update_all(status: Erp::Products::State::STATUS_DELETED)
		end
    
    # check status is true/false
    def is_draft?
      return self.status == Erp::Products::State::STATUS_DRAFT
    end
    
    def is_active?
      return self.status == Erp::Products::State::STATUS_ACTIVE
    end
    
    def is_deleted?
      return self.status == Erp::Products::State::STATUS_DELETED
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

    def self.get_active
			self.where(status: self::STATUS_ACTIVE)
		end
  end
end
