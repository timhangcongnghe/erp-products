Erp::User.class_eval do
  has_many :ratings, class_name: 'Erp::Products::Rating', foreign_key: 'user_id'
  has_many :comments, class_name: 'Erp::Products::Comment', foreign_key: 'user_id'
  
  def find_rating_by_product(product_id)
    rating = self.ratings.where(product_id: product_id).last
    rating.present? ? rating : Erp::Products::Rating.new(product_id: product_id)
  end
end