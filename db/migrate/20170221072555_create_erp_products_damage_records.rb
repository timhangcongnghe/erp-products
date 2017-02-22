class CreateErpProductsDamageRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_damage_records do |t|
      t.string :code
      t.datetime :date
      t.text :description
      t.string :status
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users
      t.references :warehouse, index: true, references: :erp_warehouses_warehouses
      
      t.timestamps
    end
  end
end
