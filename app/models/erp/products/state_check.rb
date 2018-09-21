module Erp::Products
  class StateCheck < ApplicationRecord
    validates :code, uniqueness: true
    validates :employee_id, :check_date, :presence => true
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :employee, class_name: "Erp::User"
    STATE_CHECK_STATUS_DRAFT = 'draft'
    STATE_CHECK_STATUS_ACTIVE = 'active'
    STATE_CHECK_STATUS_DELETED = 'deleted'
    
    STATUS_DRAFT = 'draft'
    STATUS_PENDING = 'pending'
    STATUS_ACTIVE = 'active'
    STATUS_DELETED = 'deleted'

    has_many :state_check_details, inverse_of: :state_check, dependent: :destroy
    accepts_nested_attributes_for :state_check_details, :reject_if => lambda { |a| a[:product_id].blank? || a[:state_id].blank? || a[:quantity].blank? || a[:quantity].to_i <= 0 }, :allow_destroy => true
    
    after_save :update_product_cache_stock
    # update product cache stock
    def update_product_cache_stock
			self.state_check_details.each do |scd|
        scd.update_product_cache_stock
      end
		end
    
    # update confirmed at
    def update_confirmed_at
      self.update_columns(confirmed_at: Time.now)
    end
    
    # Generate code
    before_validation :generate_code
    def generate_code
			if !code.present?
				num = StateCheck.where('check_date >= ? AND check_date <= ?', self.check_date.beginning_of_month, self.check_date.end_of_month).count + 1

				self.code = 'TT' + check_date.strftime("%m") + check_date.strftime("%Y").last(2) + "-" + num.to_s.rjust(3, '0')
			end
		end
    
    if Erp::Core.available?("warehouses")
			validates :warehouse_id, :presence => true
      belongs_to :warehouse, class_name: "Erp::Warehouses::Warehouse"

      def warehouse_name
        warehouse.present? ? warehouse.warehouse_name : ''
      end
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

      # global filters
      global_filter = params[:global_filter]

			if global_filter.present?

        # if has period
        if global_filter[:period].present?
          period = Erp::Periods::Period.find(global_filter[:period])
          global_filter[:from_date] = period.from_date
          global_filter[:to_date] = period.to_date
        end

				# filter by order from date
				if global_filter[:from_date].present?
					query = query.where('check_date >= ?', global_filter[:from_date].to_date.beginning_of_day)
				end

				# filter by order to date
				if global_filter[:to_date].present?
					query = query.where('check_date <= ?', global_filter[:to_date].to_date.end_of_day)
				end
			end

      # join with users table for search creator
      query = query.joins(:creator)

      # join with users table for search employee
      query = query.joins(:employee)

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

      query = query.limit(8).map{|state_check| {value: state_check.id, text: state_check.name} }
    end

    def creator_name
      creator.present? ? creator.name : ''
    end

    def employee_name
      employee.present? ? employee.name : ''
    end

    # STATUS
    def set_draft
			update_attributes(status: Erp::Products::StateCheck::STATUS_DRAFT)
		end

    def set_pending
			update_attributes(status: Erp::Products::StateCheck::STATUS_PENDING)
		end

    def set_active
			update_attributes(status: Erp::Products::StateCheck::STATUS_ACTIVE)
		end

    def set_deleted
			update_attributes(status: Erp::Products::StateCheck::STATUS_DELETED)
		end

    def self.set_draft_all
			update_all(status: Erp::Products::StateCheck::STATUS_DRAFT)
		end

    def self.set_pending_all
			update_all(status: Erp::Products::StateCheck::STATUS_PENDING)
		end

    def self.set_active_all
			update_all(status: Erp::Products::StateCheck::STATUS_ACTIVE)
		end

    def self.set_deleted_all
			update_all(status: Erp::Products::StateCheck::STATUS_DELETED)
		end
    
    # check status is true/false
    def is_draft?
      return self.status == Erp::Products::StateCheck::STATUS_DRAFT
    end
    
    def is_pending?
      return self.status == Erp::Products::StateCheck::STATUS_PENDING
    end
    
    def is_active?
      return self.status == Erp::Products::StateCheck::STATUS_ACTIVE
    end
    
    def is_deleted?
      return self.status == Erp::Products::StateCheck::STATUS_DELETED
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
    
		# total quantity
		def total_quantity
      state_check_details.sum(:quantity)
    end
    
		def self.get_pending_state_checks
      self.where(status: Erp::Products::StateCheck::STATUS_PENDING)
    end
  end
end
