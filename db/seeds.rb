user = Erp::User.first

# Create category
Erp::Products::Category.destroy_all
len_sta = Erp::Products::Category.create(name: "Standard", creator_id: user.id)
len_pre = Erp::Products::Category.create(name: "Premium", creator_id: user.id)
len_tor = Erp::Products::Category.create(name: "Toric", creator_id: user.id)
len_exp = Erp::Products::Category.create(name: "Express", creator_id: user.id)
len_2pa = Erp::Products::Category.create(name: "2PA (viễn thị)", creator_id: user.id)
len_soft = Erp::Products::Category.create(name: "Soft", creator_id: user.id)
len_spk = Erp::Products::Category.create(name: "SPK", creator_id: user.id)
len_spk_ = Erp::Products::Category.create(name: "SPK-", creator_id: user.id)
len_sph = Erp::Products::Category.create(name: "SP HI", creator_id: user.id)
len_sph_ = Erp::Products::Category.create(name: "SP HI-", creator_id: user.id)
len_liq = Erp::Products::Category.create(name: "Liquid", creator_id: user.id)

len_cats = Erp::Products::Category.all

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
Erp::Products::CategoriesPgroup.destroy_all
len_cats.each do |len_cat|
  len_cpg = Erp::Products::CategoriesPgroup.create(
    category_id: len_cat.id,
    property_group_id: len_pg.id
  )
end

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
letters = ('B'..'E').to_a
#('C'..'U').each do |x|
#  letters << "H#{x}"
#end
letters.each do |letter|
  Erp::Products::PropertiesValue.create(
    property_id: chu_p.id,
    value: letter
  )
  Erp::Products::PropertiesValue.create(
    property_id: do_p.id,
    value: do_v
  )
  do_v = do_v + 0.25
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
#(5..29).each do |number|
(5..19).each do |number|
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
    value: '10.4'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '10.5'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '10.6'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '10.8'
  ),
  #Erp::Products::PropertiesValue.create(
  #  property_id: dk_p.id,
  #  value: '11'
  #),
  #Erp::Products::PropertiesValue.create(
  #  property_id: dk_p.id,
  #  value: '11.2'
  #),
  #Erp::Products::PropertiesValue.create(
  #  property_id: dk_p.id,
  #  value: '11.4'
  #),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '11.6'
  )
]

# products
Erp::Products::Product.all.destroy_all
Erp::Products::ProductsValue.destroy_all

def create_product(user, brand, letter, number, dk_pv, len_cat, chu_pv, do_pv, so_pv, dok_pv)
  product = Erp::Products::Product.create(
    code: "#{letter}#{number.to_s.rjust(2, '0')}",
    name: "#{letter}#{number.to_s.rjust(2, '0')}-#{dk_pv.value}-#{len_cat.name}",
    category_id: len_cat.id,
    brand_id: brand.id,
    creator_id: user.id,
    price: rand(5..100)*10000
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

  Erp::Products::Product.find(product.id).update_cache_properties
end

dk_pvs.each do |dk_pv|
  do_v = 0.75
  letters.each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
    (5..29).each do |number|
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
      dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: dok_vs[:"#{number.to_s}"]).first

      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_sta, chu_pv, do_pv, so_pv, dok_pv)
      end
      if [10.4, 10.6, 10.8, 11].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_pre, chu_pv, do_pv, so_pv, dok_pv)
      end
      if [10.6, 10.8, 11, 11.4, 11.6].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_tor, chu_pv, do_pv, so_pv, dok_pv)
      end
      if [10.5, 10.6].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_exp, chu_pv, do_pv, so_pv, dok_pv)
      end

      puts "================================= #{dk_pv.value} #{letter} #{number} ======================================="

    end

    do_v = do_v + 0.25
  end
end
