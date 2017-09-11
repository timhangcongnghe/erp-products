class AddStateIdToErpProductsDamageRecordDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_products_damage_record_details, :state, index: true, references: :erp_products_states
  end
end
