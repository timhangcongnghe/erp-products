class CreateErpProductsStates < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_products_states do |t|
      t.string :name
      t.text :description
      t.string :status, default: "draft"
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
