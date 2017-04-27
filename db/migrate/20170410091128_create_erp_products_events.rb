class CreateErpProductsEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_events do |t|
      t.string :name
      t.datetime :from_date
      t.datetime :to_date
      t.string :image_url
      t.text :description
      t.boolean :archived, default: false
      t.references :user, index: true, references: :erp_users

      t.timestamps
    end
  end
end
