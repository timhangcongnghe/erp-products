class CreateErpProductsDamageRecordDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_damage_record_details do |t|
      t.integer :quantity, default: 1
      t.text :note
      t.references :product, index: true, references: :erp_products_products
      t.references :damage_record, index: true, references: :erp_products_damage_records

      t.timestamps
    end
  end
end
