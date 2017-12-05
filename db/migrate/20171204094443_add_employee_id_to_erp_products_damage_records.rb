class AddEmployeeIdToErpProductsDamageRecords < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_products_damage_records, :employee, index: true, references: :erp_users
  end
end
