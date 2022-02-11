def get_main_image
  img = get_all_images.first
  return img.nil? ? Erp::Products::ProductImage.new : img
end

def get_all_images
  product_images.where.not(image_url: nil).order('id desc')
end

# get all categories with products
def self.get_related_categories
  Erp::Products::Category.where(id: self.distinct.pluck(:category_id))
end

# get all brands with products
def self.get_related_brands
  Erp::Products::Brand.where(id: self.distinct.pluck(:brand_id))
end

def self.get_newest_products
  return self.get_active.order('created_at desc').where(is_new: true).limit(10)
end





def ratings_active
  ratings.where(archived: false)
end

def count_stars
  self.ratings_active.map(&:star)
end

def average_stars
  (count_stars.empty? ? 0 : count_stars.inject(0, :+).to_f / count_stars.length).round(1)
end

def percentage_stars(score=0)
  percentage=0
  num = self.ratings_active.where(star: score).count
  if num > 0
    percentage = num*100 / count_stars.length
  end
  return percentage
end