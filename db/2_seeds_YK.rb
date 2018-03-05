user = Erp::User.first

unit_cai = Erp::Products::Unit.where(name: "Cái").first
unit_bo = Erp::Products::Unit.where(name: "Bộ").first
unit_chai = Erp::Products::Unit.where(name: "Chai").first
unit_hop = Erp::Products::Unit.where(name: "Hộp").first
unit_tuyp = Erp::Products::Unit.where(name: "Tuýp").first
unit_lo = Erp::Products::Unit.where(name: "Lọ").first
unit_cay = Erp::Products::Unit.where(name: "Cây").first

dd_cat = Erp::Products::Category.where(name: "Dung dịch").first
bb_cat = Erp::Products::Category.where(name: "Bao bì").first
remover_cat = Erp::Products::Category.where(name: "Len remover").first
other_cat = Erp::Products::Category.where(name: "Sản phẩm khác").first
len_set = Erp::Products::Category.where(name: "Bộ sét").first
len_sp = Erp::Products::Category.where(name: "SP").first


len_pg = Erp::Products::PropertyGroup.where(
  creator_id: user.id,
  name: "Len"
).first

so_p = len_pg.properties.where(
  name: 'Số',
  creator_id: user.id
).first
dok_p = len_pg.properties.where(
  name: 'Độ K',
  creator_id: user.id
).first
dok2_p = len_pg.properties.where(
  name: 'Độ K2',
  creator_id: user.id
).first
chu_p = len_pg.properties.where(
  name: 'Chữ',
  creator_id: user.id
).first
do_p = len_pg.properties.where(
  name: 'Độ',
  creator_id: user.id
).first
dk_p = len_pg.properties.where(
  name: 'Đường kính',
  creator_id: user.id
).first




## Property Value

letters = ('A'..'T').to_a
('C'..'U').each do |x|
  letters << "H#{x}"
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

dk_pvs = [
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.2'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.3'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.4'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.5'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.6'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '10.8'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11.2'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11.3'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11.4'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11.5'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '11.6'
  ).first,
  Erp::Products::PropertiesValue.where(
    property_id: dk_p.id,
    value: '16.4'
  ).first
]


brand = Erp::Products::Brand.where(name: "Ortho-K").first



#letters = ['YSPK', 'YSPHI', 'YS', 'YO', 'YG', 'YK']
letters = ['YK']
letters.each do |letter|
  Erp::Products::PropertiesValue.create(
    property_id: chu_p.id,
    value: letter
  )
end



def create_product(user, brand, letter, number, dk_pv, len_cat, chu_pv, do_pv, so_pv, dok_pv, unit_cai, is_outside=false)
  product = Erp::Products::Product.create(
    code: "#{letter}#{number.to_s.rjust(2, '0')}",
    name: "#{letter}#{number.to_s.rjust(2, '0')}-#{dk_pv.value}-#{len_cat.name}",
    category_id: len_cat.id,
    brand_id: brand.id,
    creator_id: user.id,
    unit_id: unit_cai.id,
    price: nil, # rand(5..100)*10000,
    is_outside: is_outside
  )
  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: chu_pv.id
  ) if chu_pv.present?
  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: do_pv.id
  ) if do_pv.present?
  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: so_pv.id
  ) if so_pv.present?
  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: dok_pv.id
  ) if dok_pv.present?
  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: dk_pv.id
  ) if dk_pv.present?

  Erp::Products::Product.find(product.id).update_cache_properties
end



dk_pvs.each do |dk_pv|
  letters.each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    ["00","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      if (['YK'].include?(letter) and [10.4, 10.6, 11, 11.2].include?(dk_pv.value.to_f))
        create_product(user, brand, letter, so_tmp, dk_pv, len_sp, chu_pv, nil, so_pv, nil, unit_cai)
      end

      puts "==== #{dk_pv.value} #{letter} #{so_tmp} ===="
    end
  end
end
