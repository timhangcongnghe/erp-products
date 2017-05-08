module Erp::Products
  class Rating < ApplicationRecord
    belongs_to :product, class_name: 'Erp::Products::Product'
    belongs_to :user, class_name: 'Erp::User'
    
    validates :star, :presence => true
    validates :content, length: { minimum: 50 }
    
    # display user name
    def user_name
			user.present? ? user.name : ''
		end
    
    # display message rating
    def display_content
			content.gsub("\r\n", "<br/>").html_safe
		end
    
    # ratings count archived
    def self.count_archived
			self.where(archived: true).count
		end
  end
end
