class CreateErpProductsPriceListsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_price_lists_users do |t|
      t.references :price_list, index: true, references: :erp_products_price_lists
      t.references :user, index: true, references: :erp_users

      t.timestamps
    end
  end
end
