class CreateErpProductsStateCheckDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_products_state_check_details do |t|
      t.integer :quantity, default: 1
      t.text :note
      t.references :state, index: true, references: :erp_products_states
      t.references :product, index: true, references: :erp_products_products
      t.references :state_check, index: true, references: :erp_products_state_checks

      t.timestamps
    end
  end
end
