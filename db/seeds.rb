user = Erp::User.first

# Create category
Erp::Products::Category.destroy_all
len_cat = Erp::Products::Category.create(name: "Len Thường", creator_id: user.id)
Erp::Products::Category.create(name: "Toric", creator_id: user.id)
Erp::Products::Category.create(name: "Premium", creator_id: user.id)
Erp::Products::Category.create(name: "Fargo Express", creator_id: user.id)
Erp::Products::Category.create(name: "Len 2PA", creator_id: user.id)
Erp::Products::Category.create(name: "Len GOV (-3)", creator_id: user.id)
Erp::Products::Category.create(name: "Len GOV (+3)", creator_id: user.id)
Erp::Products::Category.create(name: "Len GOV (-7)", creator_id: user.id)
Erp::Products::Category.create(name: "Soft OK Len", creator_id: user.id)

# Brand
Erp::Products::Brand.where(name: "Ortho-K").destroy_all
brand = Erp::Products::Brand.create(name: "Ortho-K", creator_id: user.id)

# Property Group
Erp::Products::PropertyGroup.destroy_all
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
Erp::Products::Property.destroy_all
so_p = len_pg.properties.create(
  name: 'Số',
  creator_id: user.id
)
dok_p = len_pg.properties.create(
  name: 'Độ K',
  creator_id: user.id
)
chu_p = len_pg.properties.create(
  name: 'Chữ',
  creator_id: user.id
)
do_p = len_pg.properties.create(
  name: 'Độ',
  creator_id: user.id
)
dk_p = len_pg.properties.create(
  name: 'Đường kính',
  creator_id: user.id
)

# Property Value
Erp::Products::PropertiesValue.destroy_all

do_v = 0.75
('B'..'T').each do |letter|
  Erp::Products::PropertiesValue.create(
    property_id: chu_p.id,
    value: letter
  )
  Erp::Products::PropertiesValue.create(
    property_id: do_p.id,
    value: do_v
  )
  do_v = do_v + 0.75
end

dok_vs = {
  '5': '46.00/7.34',
  '6': '45.75/7.37',
  '7': '45.50/7.42',
  '8': '45.25/7.46',
  '9': '45.00/7.50',
  '10': '44.75/7.54',
  '11': '44.50/7.58',
  '12': '44.25/7.63',
  '13': '44.00/7.67',
  '14': '43.75/7.71',
  '15': '43.50/7.75',
  '16': '43.25/7.80',
  '17': '43.00/7.84',
  '18': '42.75/7.89',
  '19': '42.50/7.94',
  '20': '42.25/7.98',
  '21': '42.00/8.03',
  '22': '41.75/8.08',
  '23': '41.50/8.13',
  '24': '41.25/8.18',
  '25': '41.00/8.23',
  '26': '40.75/8.28',
  '27': '40.50/8.33',
  '28': '40.25/8.38',
  '29': '40.00/8.44',
  '1': 'K1',
  '2': 'K2',
  '3': 'K3',
  '4': 'K4',
  '30': 'K30',
  '31': 'K31',
  '32': 'K32',
  '33': 'K33',
  '34': 'K34',
  '35': 'K35',
  '36': 'K36',
}
(5..29).each do |number|
  Erp::Products::PropertiesValue.create(
    property_id: so_p.id,
    value: number.to_s.rjust(2, '0')
  )
  Erp::Products::PropertiesValue.create(
    property_id: dok_p.id,
    value: dok_vs[:"#{number.to_s}"]
  )
end

dk_pvs = [
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '10.6'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '10.8'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '11'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '11.2'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '11.6'
  )
]

# products
Erp::Products::Product.all.destroy_all
Erp::Products::ProductsValue.destroy_all

dk_pvs.each do |dk_pv|
  do_v = 0.75
  ('B'..'T').each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
    (5..29).each do |number|
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
      dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: dok_vs[:"#{number.to_s}"]).first

      product = Erp::Products::Product.create(
        code: "#{letter}#{number.to_s.rjust(2, '0')}",
        name: "#{letter}#{number.to_s.rjust(2, '0')}-#{dk_pv.value}-#{len_cat.name}",
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
        properties_value_id: do_pv.id
      )
      Erp::Products::ProductsValue.create(
        product_id: product.id,
        properties_value_id: so_pv.id
      )
      Erp::Products::ProductsValue.create(
        product_id: product.id,
        properties_value_id: dok_pv.id
      )
      Erp::Products::ProductsValue.create(
        product_id: product.id,
        properties_value_id: dk_pv.id
      )
    end

    do_v = do_v + 0.75
  end
end
