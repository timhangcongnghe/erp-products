class AddConfirmedAtToErpProductsDamageRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_damage_records, :confirmed_at, :datetime
  end
end
