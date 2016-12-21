if Erp::Core.available?("taxes")
    Erp::Taxes::Tax.class_eval do
        has_and_belongs_to_many :products, class_name: 'Erp::Products::Product', :join_table => 'erp_products_customer_taxes'
        has_and_belongs_to_many :products, class_name: 'Erp::Products::Product', :join_table => 'erp_products_vendor_taxes'
    end
end