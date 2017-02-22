class CreateErpProductsStockChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_stock_checks do |t|
      t.string :code
      t.datetime :adjustment_date
      t.text :description
      t.string :status
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users
      t.references :warehouse, index: true, references: :erp_warehouses_warehouses

      t.timestamps
    end
  end
end
