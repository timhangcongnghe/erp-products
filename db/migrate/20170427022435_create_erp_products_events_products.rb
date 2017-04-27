class CreateErpProductsEventsProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_events_products do |t|
      t.references :event, index: true, references: :erp_products_events
      t.references :product, index: true, references: :erp_products_products
    end
  end
end
