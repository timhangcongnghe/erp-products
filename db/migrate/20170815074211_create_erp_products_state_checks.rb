class CreateErpProductsStateChecks < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_products_state_checks do |t|
      t.string :name
      t.datetime :check_date
      t.text :note
      t.string :status, default: "draft"
      t.boolean :archived, default: false
      t.references :warehouse, index: true, references: :erp_warehouses_warehouses
      t.references :employee, index: true, references: :erp_users
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
