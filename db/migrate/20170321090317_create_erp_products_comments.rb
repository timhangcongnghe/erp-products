class CreateErpProductsComments < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_comments do |t|
      t.text :message
      t.integer :parent_id
      t.boolean :archived, default: false
      t.references :product, index: true, references: :erp_products_products
      t.references :user, index: true, references: :erp_users

      t.timestamps
    end
  end
end
