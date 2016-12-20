class CreateErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products do |t|
      t.string :name
      t.string :product_type
      t.string :invoicing_policy
      t.string :barcode
      t.decimal :sale_price, default: 1.0
      t.decimal :cost, default: 0.0
      t.decimal :weight, default: 0.0
      t.decimal :volume, default: 0.0
      t.decimal :customer_lead_time, default: 0.0
      t.text :internal_reference
      t.text :quotations_description
      t.text :pickings_description
      t.boolean :can_be_sold, default: true
      t.boolean :can_be_purchased, default: true
      t.boolean :archived, default: false
      t.references :category, index: true, references: :erp_products_categories
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
