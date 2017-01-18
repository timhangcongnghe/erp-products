class CreateErpProductsManufacturings < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_manufacturings do |t|
      t.string :code
      t.datetime :manufacturing_date
      t.integer :quantity, default: 1.0
      t.boolean :is_auto_reduce_part_quantity, default: true
      t.text :note
      t.string :status
      t.references :product, index: true, references: :erp_products_products
      t.references :responsible, index: true, references: :erp_contacts_contacts
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
