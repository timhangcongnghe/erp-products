class CreateErpProductsInventoryCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_inventory_categories do |t|
      t.string :name
      t.string :hot_name
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users
      t.integer :custom_order

      t.timestamps
    end
  end
end
