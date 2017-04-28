module Erp::Products
  class Event < ApplicationRecord
    validates :name, :from_date, :to_date, :presence => true
    mount_uploader :image_url, Erp::Products::EventImageUploader
    
    belongs_to :creator, class_name: "Erp::User"
    has_and_belongs_to_many :products
    
    has_many :events_products, dependent: :destroy
    accepts_nested_attributes_for :events_products, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
    
    def self.events_active
      self.where(archived: false)
    end
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

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

      # showing archived items if show_archived is not true
			query = query.where(archived: false) if show_archived == false

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

      query = query.limit(8).map{|category| {value: category.id, text: category.name} }
    end
    
    def archive
			update_columns(archived: true)
		end
		
		def unarchive
			update_columns(archived: false)
		end
    
    def self.archive_all
			update_all(archived: true)
		end
    
    def self.unarchive_all
			update_all(archived: false)
		end
    
    # get future events
    def self.get_future_events
      self.events_active.where("from_date >= ?", Time.now)
                        .order("from_date DESC")
    end
    
    # get current events
    def self.get_current_events
      self.events_active.where("from_date <= ? and to_date >= ?", Time.now, Time.now)
                        .order("from_date DESC")
    end
    
    # get past events
    def self.get_past_events
      self.events_active.where("to_date <= ?", Time.now)
                        .order("from_date DESC")
    end
  end
end
