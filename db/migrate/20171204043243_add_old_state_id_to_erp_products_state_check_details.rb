class AddOldStateIdToErpProductsStateCheckDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_products_state_check_details, :old_state, index: true, references: :erp_products_states
  end
end
