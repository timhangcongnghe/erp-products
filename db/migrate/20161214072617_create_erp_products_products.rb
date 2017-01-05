class CreateErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products do |t|
      t.string :name
      t.string :code
      t.string :product_type
      t.string :barcode
      t.decimal :price, default: 1.0
      t.decimal :cost, default: 0.0
      t.decimal :on_hand, default: 0.0
      t.decimal :weight, default: 0.0
      t.decimal :volume, default: 0.0
      t.decimal :stock_min, default: 0.0
      t.decimal :stock_max, default: 999999.0
      t.text :description
      t.text :internal_note
      t.boolean :can_be_sold, default: true
      t.boolean :can_be_purchased, default: true
      t.boolean :is_for_pos, default:true
      t.boolean :point_enabled, default: true
      t.boolean :archived, default: false
      t.references :category, index: true, references: :erp_products_categories
      t.references :unit, index: true, references: :erp_products_units
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
