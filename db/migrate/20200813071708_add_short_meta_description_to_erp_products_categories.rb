class AddShortMetaDescriptionToErpProductsCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_categories, :short_meta_description, :string
  end
end
