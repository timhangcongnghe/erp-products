class ChangeArchivedDefaultToErpProductsRatings < ActiveRecord::Migration[5.0]
  def change
    change_column_default :erp_products_ratings, :archived, from: false, to: true
  end
end
