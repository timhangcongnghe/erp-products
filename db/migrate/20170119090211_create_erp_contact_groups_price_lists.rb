class CreateErpContactGroupsPriceLists < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_contact_groups_price_lists do |t|
      t.references :price_list, index: true, references: :erp_products_price_lists
      t.references :contact_group, index: true, references: :erp_contacts_contact_groups

      t.timestamps
    end
  end
end
