class AddDimenstionsAndWeightsAndWarrantyToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :dimentions, :string
    add_column :erp_products_products, :weights, :string
    add_column :erp_products_products, :warranty, :string
  end
end
