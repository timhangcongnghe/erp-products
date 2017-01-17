class CreateErpProductsPriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_price_lists do |t|
      t.string :name
      t.datetime :valid_from
      t.datetime :valid_to
      t.boolean :active, default: true
      t.boolean :all_warehouses, default: true
      t.boolean :all_users, default: true
      t.boolean :all_contact_groups, default: true
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
