class AddDatasheetToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :datasheet, :string
  end
end