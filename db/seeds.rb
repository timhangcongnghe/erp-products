user = Erp::User.first

# State
Erp::Products::State.destroy_all
Erp::Products::State.create(name: "Mới", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)
Erp::Products::State.create(name: "Xước", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)
Erp::Products::State.create(name: "Vỡ", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)

# Unit
Erp::Products::Unit.destroy_all
unit_cai = Erp::Products::Unit.create(name: "Cái", creator_id: user.id)
unit_bo = Erp::Products::Unit.create(name: "Bộ", creator_id: user.id)
unit_chai = Erp::Products::Unit.create(name: "Chai", creator_id: user.id)
unit_hop = Erp::Products::Unit.create(name: "Hộp", creator_id: user.id)
unit_tuyp = Erp::Products::Unit.create(name: "Tuýp", creator_id: user.id)
unit_lo = Erp::Products::Unit.create(name: "Lọ", creator_id: user.id)
unit_cay = Erp::Products::Unit.create(name: "Cây", creator_id: user.id)

# Create category
Erp::Products::Category.destroy_all
len_sta = Erp::Products::Category.create(name: "Standard", creator_id: user.id)
len_pre = Erp::Products::Category.create(name: "Premium", creator_id: user.id)
len_tor = Erp::Products::Category.create(name: "Toric", creator_id: user.id)
len_exp = Erp::Products::Category.create(name: "Express", creator_id: user.id)
len_2pa = Erp::Products::Category.create(name: "2PA (viễn thị)", creator_id: user.id)
len_soft = Erp::Products::Category.create(name: "Soft", creator_id: user.id)
len_liq = Erp::Products::Category.create(name: "Liquid", creator_id: user.id)
# Len SP
len_sp = Erp::Products::Category.create(name: "Len SP", creator_id: user.id)

len_cats = Erp::Products::Category.all

# Brand
Erp::Products::Brand.where(name: "Ortho-K").destroy_all
brand = Erp::Products::Brand.create(name: "Ortho-K", creator_id: user.id)

# State
Erp::Products::State.destroy_all
states = ['Mới', 'Xước', 'Vỡ', 'Sau 1 năm']
states.each do |st|
  Erp::Products::State.create(name: st, creator_id: user.id)
end

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
letters = ('B'..'T').to_a
('C'..'U').each do |x|
  letters << "H#{x}"
end
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
(1..36).each do |number|
#(5..19).each do |number|
  Erp::Products::PropertiesValue.create(
    property_id: so_p.id,
    value: number.to_s.rjust(2, '0')
  )
  Erp::Products::PropertiesValue.create(
    property_id: dok_p.id,
    value: dok_vs[:"#{number.to_s}"]
  )
end

Erp::Products::PropertiesValue.create(
  property_id: so_p.id,
  value: '0'
)
Erp::Products::PropertiesValue.create(
  property_id: so_p.id,
  value: '00'
)

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
    value: '11.4'
  ),
  Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: '11.6'
  )
]

# products
Erp::Products::Product.all.destroy_all
Erp::Products::ProductsValue.destroy_all

def create_product(user, brand, letter, number, dk_pv, len_cat, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
  product = Erp::Products::Product.create(
    code: "#{letter}#{number.to_s.rjust(2, '0')}",
    name: "#{letter}#{number.to_s.rjust(2, '0')}-#{dk_pv.value}-#{len_cat.name}",
    category_id: len_cat.id,
    brand_id: brand.id,
    creator_id: user.id,
    unit_id: unit_cai.id,
    price: nil, # rand(5..100)*10000
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

# default lens
dk_pvs.each do |dk_pv|
  do_v = 0.75
  letters.each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
    (5..29).each do |number|
    #(5..19).each do |number|
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
      dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: dok_vs[:"#{number.to_s}"]).first

      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_sta, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
      end
      if [10.4, 10.6, 10.8, 11].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_pre, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
      end
      if [10.6, 10.8, 11, 11.4, 11.6].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_tor, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
      end
      if [10.5, 10.6].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, number, dk_pv, len_exp, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
      end

      puts "==== #{dk_pv.value} #{letter} #{number} ===="

    end
    do_v = do_v + 0.25
  end
end

# for K letter
dk_pvs.each do |dk_pv|
  do_v = 0.75
  ['K'].each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
    [1,2,3,4,30,31,32,33,34,35,36].each do |number|
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

      puts "==== #{dk_pv.value} #{letter} #{number} ===="

    end
    do_v = do_v + 0.25
  end
end

# add category group
Erp::Products::CategoriesPgroup.create(
  category_id: len_soft.id,
  property_group_id: len_pg.id
)

(1..8).each do |number|
  pv_tmp = Erp::Products::PropertiesValue.create(
    property_id: dk_p.id,
    value: "#{number}.00"
  )

  product = Erp::Products::Product.create(
    code: "#{len_soft.name} #{pv_tmp.value}",
    name: "#{len_soft.name} #{pv_tmp.value}",
    category_id: len_soft.id,
    brand_id: brand.id,
    unit_id: unit_cai.id,
    creator_id: user.id,
    price: nil,
  )

  Erp::Products::ProductsValue.create(
    product_id: product.id,
    properties_value_id: pv_tmp.id
  )

  Erp::Products::Product.find(product.id).update_cache_properties
end

# Others
arr_tmp = [
  {name: "Bộ set thử Scleral A (hộp màu đỏ) 16 len/ bộ", unit_id: unit_bo.id},
  {name: "Bộ set thử Scleral B (hộp màu đỏ) 16 len/ bộ", unit_id: unit_bo.id},
  {name: "Bộ sét SCL Plano  (từ SCL1 - SCL27)", unit_id: unit_bo.id},
  {name: "Bộ set thử -3 (K5-K29)", unit_id: unit_bo.id},
  {name: "Bộ set thử -5 (S5-S29)", unit_id: unit_bo.id},
  {name: "Bộ set thử -7 (HI5-HI29)", unit_id: unit_bo.id},
  {name: "Bộ set thử -3 Tonic (K5-K29)", unit_id: unit_bo.id},
  {name: "Kinh Adlens", unit_id: unit_cai.id},
  {name: "Len không mã", unit_id: unit_cai.id},
  {name: "Bộ kính thị lực", unit_id: unit_bo.id},
  {name: "Avizor 15mm (Lacrifresh comfort)", unit_id: unit_chai.id},
  {name: "Avizor GP multi (60ml)", unit_id: unit_chai.id},
  {name: "Avizor GP multi (240ml)", unit_id: unit_chai.id},
  {name: "Natural Ophthalmics Thick (đêm)", unit_id: unit_chai.id},
  {name: "Natural Ophthalmics Thin (ngày)", unit_id: unit_chai.id},
  {name: "DD Boston Starter kitDD Boston Simplus(105ml +5ml)", unit_id: unit_chai.id},
  {name: "DD Boston Simplus(105ml +5ml)", unit_id: unit_chai.id},
  {name: "DD boston reweting drops 10ml", unit_id: unit_chai.id},
  {name: "Lacripure (1Hộp=98 tuýp)", unit_id: unit_hop.id},
  {name: "Lacripure (tuýp)", unit_id: unit_tuyp.id},
  {name: "DD Menicon progent (7 treatment)", unit_id: unit_bo.id},
  {name: "DD boston simplus 120ml", unit_id: unit_chai.id},
  {name: "DD Samilvidone 10ml", unit_id: unit_chai.id},
  {name: "DD One Step 355ml", unit_id: unit_chai.id},
  {name: "Fluorescein sodium(giay nhuom)", unit_id: unit_hop.id},
  {name: "Hủ giấy nhuộm", unit_id: unit_lo.id},
  {name: "Lens remover (không lỗ)", unit_id: unit_cai.id},
  {name: "Lens remover (có lỗ 60, xéo 19)", unit_id: unit_cai.id},
  {name: "Lens remover Scleral", unit_id: unit_cai.id},
  {name: "Khay dung len (khay màu: 105 cái)", unit_id: unit_cai.id},
  {name: "Đèn khám mắt (cay viet)", unit_id: unit_cay.id},
  {name: "Hộp Gỗ 240", unit_id: unit_hop.id},
  {name: "Hộp gỗ bộ sét", unit_id: unit_hop.id},
  {name: "Túi giấy", unit_id: unit_cai.id},
  {name: "ReNovoOculus (Tế bào gốc)", unit_id: unit_hop.id},
  {name: "Hũ đựng len", unit_id: unit_cai.id},
  {name: "Khung hình", unit_id: unit_cai.id},
  {name: "Hộp gỗ 60", unit_id: unit_hop.id},
  {name: "Túi vải fargo", unit_id: unit_cai.id},
  {name: "Omega-3 (Fish oil)", unit_id: unit_hop.id},
  {name: "Thước đo giác mạc", unit_id: unit_cai.id},
]

dd_cat = Erp::Products::Category.create(name: "Dung dịch", creator_id: user.id)
arr_tmp.each do |item|
  product = Erp::Products::Product.create(
    code: item[:name],
    name: item[:name],
    category_id: dd_cat.id,
    brand_id: brand.id,
    unit_id: item[:unit_id],
    creator_id: user.id,
    price: nil,
  )
  Erp::Products::Product.find(product.id).update_cache_properties
end


################################### spK SPK #########################################################

# đường kính + số: spK + SPK
dk_so_s = [
  {
    dk: "10.4",
    so_s: [
      "00","0","1","2","3","4","5","6","7","8","9","10","11","12","13"
    ],
  },
  {
    dk: "10.8",
    so_s: [
      "14","15","16","17","18","19"
    ],
  },
  {
    dk: "11.2",
    so_s: [
      "20","21","22","23","24","25","26","27","28","29"
    ],
  }
]

# more property value
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "spK"
)
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "SPK"
)


# spk import
['spK','SPK'].each do |code_tmp|
  dk_so_s.each_with_index do |row|
    dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:dk]).first
    row[:so_s].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))

      chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: code_tmp).first
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      puts "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}"

      product = Erp::Products::Product.create(
        code: "#{chu_pv.value}#{so_pv.value}",
        name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}",
        category_id: len_sp.id,
        brand_id: brand.id,
        creator_id: user.id,
        unit_id: unit_cai.id,
        price: nil, # rand(5..100)*10000
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

      Erp::Products::Product.find(product.id).update_cache_properties
    end
  end
end


################################### spHI #########################################################

# đường kính + số: spK + SPK
dk_so_s = [
  {
    dk: "10.8",
    so_s: [
      "00","0","1","2","3","4","5","6","7","8","9","10","11","12","13"
    ],
  },
  {
    dk: "11.2",
    so_s: [
      "14","15","16","17","18","19"
    ],
  },
  {
    dk: "11.6",
    so_s: [
      "20","21","22","23","24","25","26","27","28","29"
    ],
  },
]

# more property value
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "spHI"
)

# spk import
['spHI'].each do |code_tmp|
  dk_so_s.each_with_index do |row|
    dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:dk]).first
    row[:so_s].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))

      chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: code_tmp).first
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      puts "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}"

      product = Erp::Products::Product.create(
        code: "#{chu_pv.value}#{so_pv.value}",
        name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}",
        category_id: len_sp.id,
        brand_id: brand.id,
        creator_id: user.id,
        unit_id: unit_cai.id,
        price: nil, # rand(5..100)*10000
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

      Erp::Products::Product.find(product.id).update_cache_properties
    end
  end
end


################################### SpHI #########################################################

# đường kính + số: SpHI
dk_so_s = [
  {
    dk: "11.2",
    so_s: [
      "20","28","29"
    ],
  },
]

# more property value
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "SpHI"
)

# spk import
['SpHI'].each do |code_tmp|
  dk_so_s.each_with_index do |row|
    dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:dk]).first
    row[:so_s].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))

      chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: code_tmp).first
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      puts "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}"

      product = Erp::Products::Product.create(
        code: "#{chu_pv.value}#{so_pv.value}",
        name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}",
        category_id: len_sp.id,
        brand_id: brand.id,
        creator_id: user.id,
        unit_id: unit_cai.id,
        price: nil, # rand(5..100)*10000
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

      Erp::Products::Product.find(product.id).update_cache_properties
    end
  end
end


################################### HYPS #########################################################

# đường kính + số: HYPS
dk_so_s = [
  {
    dk: "10.6",
    so_s: [
      "5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","28","29"
    ],
  },
]

# more property value
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "HYPS"
)

# spk import
['HYPS'].each do |code_tmp|
  dk_so_s.each_with_index do |row|
    dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:dk]).first
    row[:so_s].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))

      chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: code_tmp).first
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      puts "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}"

      product = Erp::Products::Product.create(
        code: "#{chu_pv.value}#{so_pv.value}",
        name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}",
        category_id: len_sp.id,
        brand_id: brand.id,
        creator_id: user.id,
        unit_id: unit_cai.id,
        price: nil, # rand(5..100)*10000
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

      Erp::Products::Product.find(product.id).update_cache_properties
    end
  end
end


################################### HYPO #########################################################

# đường kính + số: HYPS
dk_so_s = [
  {
    dk: "10.6",
    so_s: [
      "5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","28","29"
    ],
  },
]

# more property value
Erp::Products::PropertiesValue.create(
  property_id: chu_p.id,
  value: "HYPO"
)

# spk import
['HYPO'].each do |code_tmp|
  dk_so_s.each_with_index do |row|
    dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:dk]).first
    row[:so_s].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))

      chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: code_tmp).first
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      puts "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}"

      product = Erp::Products::Product.create(
        code: "#{chu_pv.value}#{so_pv.value}",
        name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_sp.name}",
        category_id: len_sp.id,
        brand_id: brand.id,
        creator_id: user.id,
        unit_id: unit_cai.id,
        price: nil, # rand(5..100)*10000
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

      Erp::Products::Product.find(product.id).update_cache_properties
    end
  end
end
