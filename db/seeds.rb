user = Erp::User.first

# Create category
Erp::Products::Category.where(name: "Len").destroy_all
len_cat = Erp::Products::Category.create(name: "Len Thường", creator_id: user.id)

# Brand
Erp::Products::Brand.where(name: "Ortho-K").destroy_all
brand = Erp::Products::Brand.create(name: "Ortho-K", creator_id: user.id)

# Property Group
Erp::Products::PropertyGroup.all.destroy_all
len_pg = Erp::Products::PropertyGroup.create(
  creator_id: user.id,
  name: "Len"
)

# CategoriesPgroup
Erp::Products::CategoriesPgroup.where(category_id: len_cat.id).where(property_group_id: len_pg.id).destroy_all
len_cpg = Erp::Products::CategoriesPgroup.create(
  category_id: len_cat.id,
  property_group_id: len_pg.id
)

# Property
len_pg.properties.destroy_all
so_p = len_pg.properties.create(
  name: 'Số',
  creator_id: user.id
)
chu_p = len_pg.properties.create(
  name: 'Chữ',
  creator_id: user.id
)
dk_p = len_pg.properties.create(
  name: 'Đường kính',
  creator_id: user.id
)

# Property Value
('B'..'T').each do |letter|
  Erp::Products::PropertiesValue.create(
    property_id: chu_p.id,
    value: letter
  )
end
(5..29).each do |number|
  Erp::Products::PropertiesValue.create(
    property_id: so_p.id,
    value: number
  )
end

dk_pv = Erp::Products::PropertiesValue.create(
  property_id: dk_p.id,
  value: '10.6'
)

# products
Erp::Products::Product.all.destroy_all
('B'..'T').each do |letter|
  chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
  (5..29).each do |number|
    so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number).first

    product = Erp::Products::Product.create(
      code: "#{letter}#{number}-#{dk_pv.value}-#{len_cat.name}",
      name: "#{letter}#{number}-#{dk_pv.value}-#{len_cat.name}",
      category_id: len_cat.id,
      brand_id: brand.id,
      creator_id: user.id
    )
    Erp::Products::ProductsValue.create(
      product_id: product.id,
      properties_value_id: chu_pv.id
    )
    Erp::Products::ProductsValue.create(
      product_id: product.id,
      properties_value_id: so_pv.id
    )
    Erp::Products::ProductsValue.create(
      product_id: product.id,
      properties_value_id: dk_pv.id
    )
  end
end
