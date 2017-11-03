class AddIsCallToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :is_call, :boolean, default: false
  end
end
