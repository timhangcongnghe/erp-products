user = Erp::User.first

## State
#Erp::Products::State.destroy_all
#Erp::Products::State.create(name: "Mới", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)
#Erp::Products::State.create(name: "Xước", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)
#Erp::Products::State.create(name: "Vỡ", status: Erp::Products::State::STATE_STATUS_ACTIVE, creator_id: user.id)
#
## Unit
#Erp::Products::Unit.destroy_all
#unit_cai = Erp::Products::Unit.create(name: "Cái", creator_id: user.id)
#unit_bo = Erp::Products::Unit.create(name: "Bộ", creator_id: user.id)
#unit_chai = Erp::Products::Unit.create(name: "Chai", creator_id: user.id)
#unit_hop = Erp::Products::Unit.create(name: "Hộp", creator_id: user.id)
#unit_tuyp = Erp::Products::Unit.create(name: "Tuýp", creator_id: user.id)
#unit_lo = Erp::Products::Unit.create(name: "Lọ", creator_id: user.id)
#unit_cay = Erp::Products::Unit.create(name: "Cây", creator_id: user.id)
#
## Parent categories
#
## Create categories
#Erp::Products::Category.destroy_all
#
#len_hard_parent = Erp::Products::Category.create(name: "Len cứng", creator_id: user.id)
#  len_sta = Erp::Products::Category.create(name: "Standard", creator_id: user.id, parent_id: len_hard_parent.id)
#  len_pre = Erp::Products::Category.create(name: "Premium", creator_id: user.id, parent_id: len_hard_parent.id)
#  len_tor = Erp::Products::Category.create(name: "Toric", creator_id: user.id, parent_id: len_hard_parent.id)
#  len_exp = Erp::Products::Category.create(name: "Express", creator_id: user.id, parent_id: len_hard_parent.id)
#  len_cus = Erp::Products::Category.create(name: "Custom", creator_id: user.id, parent_id: len_hard_parent.id)
#    len_cus_gov = Erp::Products::Category.create(name: "GOV", creator_id: user.id, parent_id: len_cus.id)
#    len_cus_scl = Erp::Products::Category.create(name: "SCL", creator_id: user.id, parent_id: len_cus.id)
#    len_cus_cus = Erp::Products::Category.create(name: "CUS", creator_id: user.id, parent_id: len_cus.id)
#
#  len_sp = Erp::Products::Category.create(name: "SP", creator_id: user.id, parent_id: len_hard_parent.id)
#  len_other = Erp::Products::Category.create(name: "Len khác", creator_id: user.id, parent_id: len_hard_parent.id)
#
## Bộ set
#len_set = Erp::Products::Category.create(name: "Bộ sét", creator_id: user.id)
#
## Len mềm
#len_soft_parent = Erp::Products::Category.create(name: "Len mềm", creator_id: user.id)
#  len_soft = Erp::Products::Category.create(name: "Soft OK", creator_id: user.id, parent_id: len_soft_parent.id)
#
## Other cats
#dd_cat = Erp::Products::Category.create(name: "Dung dịch", creator_id: user.id)
#bb_cat = Erp::Products::Category.create(name: "Bao bì", creator_id: user.id)
#remover_cat = Erp::Products::Category.create(name: "Len remover", creator_id: user.id)
#other_cat = Erp::Products::Category.create(name: "Sản phẩm khác", creator_id: user.id)
#
#len_cats = Erp::Products::Category.where(parent_id: [len_soft_parent.id, len_hard_parent.id, len_cus.id])
#
## Brand
#Erp::Products::Brand.where(name: "Ortho-K").destroy_all
#brand = Erp::Products::Brand.create(name: "Ortho-K", creator_id: user.id)
#
#
#
#
#
#
#
#
########################## OTHER PRODUCTS #########################################
## arrays
#arr_tmp = [
#  {name: "Avizor 15mm (Lacrifresh comfort)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "Avizor GP multi (60ml)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "Avizor GP multi (240ml)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "Natural Ophthalmics Thick (đêm)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "Natural Ophthalmics Thin (ngày)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Boston Starter kit", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Boston Simplus(105ml +5ml)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Boston reweting drops 10ml", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Lacripure (1Hộp=98 tuýp)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Menicon progent (7 treatment)", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Boston simplus 120ml", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Samilvidone 10ml", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD One Step 355ml", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "DD Natural Tear Stimulation Forte", unit_id: unit_chai.id, category_id: dd_cat.id},
#  {name: "Natural Ophthalmics -women's Tear Stimulation (ngày)", unit_id: unit_chai.id, category_id: dd_cat.id},
#
#  {name: "Túi vải fargo", unit_id: unit_cai.id, category_id: bb_cat.id},
#  {name: "Túi giấy", unit_id: unit_cai.id, category_id: bb_cat.id},
#  {name: "Hộp gỗ bộ sét", unit_id: unit_hop.id, category_id: bb_cat.id},
#  {name: "Hộp Gỗ 240", unit_id: unit_hop.id, category_id: bb_cat.id},
#  {name: "Hộp gỗ 60", unit_id: unit_hop.id, category_id: bb_cat.id},
#
#  {name: "Fluorescein sodium(giay nhuom)", unit_id: unit_hop.id, category_id: other_cat.id},
#  {name: "Khay đựng len (khay màu: 105 cái)", unit_id: unit_cai.id, category_id: other_cat.id},
#  {name: "Đèn khám mắt (cay viet)", unit_id: unit_cai.id, category_id: other_cat.id},
#  {name: "ReNovoOculus (Tế bào gốc)", unit_id: unit_hop.id, category_id: other_cat.id},
#  {name: "Hũ đựng len", unit_id: unit_cai.id, category_id: other_cat.id},
#  {name: "Khung hình", unit_id: unit_cai.id, category_id: other_cat.id},
#  {name: "Omega-3 (Fish oil)", unit_id: unit_hop.id, category_id: other_cat.id},
#  {name: "Thước đo giác mạc", unit_id: unit_cai.id, category_id: other_cat.id},
#
#  {name: "Lens remover (thẳng không lỗ)", unit_id: unit_cai.id, category_id: remover_cat.id},
#  {name: "Lens remover (thẳng có lỗ )", unit_id: unit_cai.id, category_id: remover_cat.id},
#  {name: "Lens remover ( xéo )", unit_id: unit_cai.id, category_id: remover_cat.id},
#  {name: "Cây gắn len (Lens remover Scleral)", unit_id: unit_cai.id, category_id: remover_cat.id},
#
#  {name: "Bộ set thử Scleral A ( 16 len/ bộ)", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ set thử Scleral B ( 16 len/ bộ)", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ sét Scleral Plano  (từ SCL1 - SCL27) Bộ E", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ set thử -3 (K5-K29)", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ set thử -5 (S5-S29)", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ set thử -7 (HI5-HI29)", unit_id: unit_bo.id, category_id: len_set.id},
#  {name: "Bộ set thử -3 Toric (K5-K29)", unit_id: unit_bo.id, category_id: len_set.id},
#]
#
#arr_tmp.each do |item|
#  product = Erp::Products::Product.create(
#    code: item[:name],
#    name: item[:name],
#    category_id: item[:category_id],
#    brand_id: nil,
#    unit_id: item[:unit_id],
#    creator_id: user.id,
#    price: nil,
#  )
#  Erp::Products::Product.find(product.id).update_cache_properties
#end
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
## State
#Erp::Products::State.destroy_all
#states = ['Mới', 'Xước', 'Vỡ', 'Sau 1 năm']
#states.each do |st|
#  Erp::Products::State.create(name: st, creator_id: user.id)
#end
#
## Property Group
#Erp::Products::PropertyGroup.destroy_all
#len_pg = Erp::Products::PropertyGroup.create(
#  creator_id: user.id,
#  name: "Len"
#)
#
## CategoriesPgroup
#Erp::Products::CategoriesPgroup.destroy_all
#len_cats.each do |len_cat|
#  len_cpg = Erp::Products::CategoriesPgroup.create(
#    category_id: len_cat.id,
#    property_group_id: len_pg.id
#  )
#end
#
## Property
#Erp::Products::Property.destroy_all
#so_p = len_pg.properties.create(
#  name: 'Số',
#  creator_id: user.id
#)
#dok_p = len_pg.properties.create(
#  name: 'Độ K',
#  creator_id: user.id
#)
#chu_p = len_pg.properties.create(
#  name: 'Chữ',
#  creator_id: user.id
#)
#do_p = len_pg.properties.create(
#  name: 'Độ',
#  creator_id: user.id
#)
#dk_p = len_pg.properties.create(
#  name: 'Đường kính',
#  creator_id: user.id
#)
#
## Property Value
#Erp::Products::PropertiesValue.destroy_all
#
#do_v = 0.5
#letters = ('A'..'T').to_a
#('C'..'U').each do |x|
#  letters << "H#{x}"
#end
#letters.each do |letter|
#  Erp::Products::PropertiesValue.create(
#    property_id: chu_p.id,
#    value: letter
#  )
#  Erp::Products::PropertiesValue.create(
#    property_id: do_p.id,
#    value: do_v
#  )
#  do_v = do_v + 0.25
#end
#
#dok_vs = {
#  '5': '46.00/7.34',
#  '6': '45.75/7.37',
#  '7': '45.50/7.42',
#  '8': '45.25/7.46',
#  '9': '45.00/7.50',
#  '10': '44.75/7.54',
#  '11': '44.50/7.58',
#  '12': '44.25/7.63',
#  '13': '44.00/7.67',
#  '14': '43.75/7.71',
#  '15': '43.50/7.75',
#  '16': '43.25/7.80',
#  '17': '43.00/7.84',
#  '18': '42.75/7.89',
#  '19': '42.50/7.94',
#  '20': '42.25/7.98',
#  '21': '42.00/8.03',
#  '22': '41.75/8.08',
#  '23': '41.50/8.13',
#  '24': '41.25/8.18',
#  '25': '41.00/8.23',
#  '26': '40.75/8.28',
#  '27': '40.50/8.33',
#  '28': '40.25/8.38',
#  '29': '40.00/8.44',
#  '1': 'K1',
#  '2': 'K2',
#  '3': 'K3',
#  '4': 'K4',
#  '30': 'K30',
#  '31': 'K31',
#  '32': 'K32',
#  '33': 'K33',
#  '34': 'K34',
#  '35': 'K35',
#  '36': 'K36',
#}
#(1..36).each do |number|
##(5..19).each do |number|
#  Erp::Products::PropertiesValue.create(
#    property_id: so_p.id,
#    value: number.to_s.rjust(2, '0')
#  )
#  Erp::Products::PropertiesValue.create(
#    property_id: dok_p.id,
#    value: dok_vs[:"#{number.to_s}"]
#  )
#end
#
#Erp::Products::PropertiesValue.create(
#  property_id: so_p.id,
#  value: '0'
#)
#Erp::Products::PropertiesValue.create(
#  property_id: so_p.id,
#  value: '00'
#)
#
#dk_pvs = [
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.2'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.3'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.4'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.5'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.6'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '10.8'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11.2'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11.3'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11.4'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11.5'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '11.6'
#  ),
#  Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: '16.4'
#  )
#]
#
## products
#Erp::Products::Product.all.destroy_all
#Erp::Products::ProductsValue.destroy_all
#
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
#
#
#
#
#
#
#
#
#
#
#
#
############################################## LENS IMPORTING ##################################################
## default lens
#dk_pvs.each do |dk_pv|
#  do_v = 0.5
#  letters.each do |letter|
#    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
#    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
#    (5..29).each do |number|
#    #(5..19).each do |number|
#      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
#      dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: dok_vs[:"#{number.to_s}"]).first
#
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_sta, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_pre, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_tor, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#
#      if [10.5].include?(dk_pv.value.to_f) and ('B'..'O').include?(letter)
#        create_product(user, brand, letter, number, dk_pv, len_exp, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#
#      puts "==== #{dk_pv.value} #{letter} #{number} ===="
#
#    end
#    do_v = do_v + 0.25
#  end
#end
#
## for K letter
#dk_pvs.each do |dk_pv|
#  do_v = 0.75
#  ['K'].each do |letter|
#    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
#    do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: do_v.to_s).first
#    [1,2,3,4,30,31,32,33,34,35,36].each do |number|
#      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
#      dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: dok_vs[:"#{number.to_s}"]).first
#
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_sta, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_pre, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#      if [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)
#        create_product(user, brand, letter, number, dk_pv, len_tor, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#
#      if [10.5].include?(dk_pv.value.to_f) and ('B'..'O').include?(letter)
#        create_product(user, brand, letter, number, dk_pv, len_exp, chu_pv, do_pv, so_pv, dok_pv, unit_cai)
#      end
#
#      puts "==== #{dk_pv.value} #{letter} #{number} ===="
#
#    end
#    do_v = do_v + 0.25
#  end
#end
#
#
#
#
#
#
#
#
#
#
#
#
############################################## LEN SOFT ##################################################
## add category group
#(1..8).each do |number|
#  pv_tmp = Erp::Products::PropertiesValue.create(
#    property_id: dk_p.id,
#    value: "#{number}.00"
#  )
#
#  product = Erp::Products::Product.create(
#    code: "#{len_soft.name} #{pv_tmp.value}",
#    name: "#{len_soft.name} #{pv_tmp.value}",
#    category_id: len_soft.id,
#    brand_id: brand.id,
#    unit_id: unit_cai.id,
#    creator_id: user.id,
#    price: nil,
#  )
#
#  Erp::Products::ProductsValue.create(
#    product_id: product.id,
#    properties_value_id: pv_tmp.id
#  )
#
#  Erp::Products::Product.find(product.id).update_cache_properties
#end
#
#
#
#
#
#
#
#
##################################### LEN SP #########################################################
#
#
#letters = ['spK', 'SPK', 'spHI', 'SPHI', 'HYPS', 'HYPO', 'HYPG']
#letters.each do |letter|
#  Erp::Products::PropertiesValue.create(
#    property_id: chu_p.id,
#    value: letter
#  )
#end
#
#dk_pvs.each do |dk_pv|
#  letters.each do |letter|
#    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
#    ["00","0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29"].each do |so_tmp|
#      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))
#      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first
#
#      if (!['HYPS', 'HYPO'].include?(letter) and [10.4, 10.6, 10.8, 11, 11.2, 11.4].include?(dk_pv.value.to_f)) or (['HYPS', 'HYPO'].include?(letter) and [10.6].include?(dk_pv.value.to_f))
#        create_product(user, brand, letter, so_tmp, dk_pv, len_sp, chu_pv, nil, so_pv, nil, unit_cai)
#      end
#
#      puts "==== #{dk_pv.value} #{letter} #{so_tmp} ===="
#    end
#  end
#end

################################################## PORTABLE ######################################################
################################################## LEN CUS #######################################################
#
#len_cus_gov = Erp::Products::Category.where(name: "GOV").first
#len_cus_scl = Erp::Products::Category.where(name: "SCL").first
#len_cus_cus = Erp::Products::Category.where(name: "CUS").first
#
#brand = Erp::Products::Brand.where(name: "Ortho-K").first
#
#unit_cai = Erp::Products::Unit.where(name: "Cái").first
#
#lens_arr = [
#  {cat: len_cus_gov, name: 'HOANG MIEN'},
#  {cat: len_cus_scl, name: 'QUAN VUI'},
#  {cat: len_cus_cus, name: 'BS HIEN PHAM'},
#  {cat: len_cus_cus, name: 'TRUNG - BS HOA (MP)'},
#  {cat: len_cus_cus, name: 'NGOC ANH -  BS HUYEN'},
#  {cat: len_cus_scl, name: 'TRAN KHOA BMAI'},
#  {cat: len_cus_gov, name: 'MONG HANG - BLIEU'},
#  {cat: len_cus_gov, name: 'HDAT - BLIEU'},
#  {cat: len_cus_cus, name: 'QU HIEN - B PHUOC'},
#  {cat: len_cus_cus, name: 'STOCK ( HI21 - 10.6)'},
#  {cat: len_cus_cus, name: 'VU QUANG HAI'},
#  {cat: len_cus_cus, name: 'HUYEN TRANG - BLIEU'},
#]
#
#lens_arr.each do |row|
#  product = Erp::Products::Product.create(
#    code: "#{row[:cat].name} / #{row[:name]}",
#    name: "#{row[:cat].name} / #{row[:name]}",
#    category_id: row[:cat].id,
#    brand_id: brand.id,
#    unit_id: unit_cai.id,
#    creator_id: user.id,
#    price: nil,
#  )
#
#  Erp::Products::Product.find(product.id).update_cache_properties
#end


################################################## PORTABLE ######################################################
################################################## LEN OTHER #######################################################

brand = Erp::Products::Brand.where(name: "Ortho-K").first
unit_cai = Erp::Products::Unit.where(name: "Cái").first

so_p = Erp::Products::Property.where(name: 'Số').first
dok_p = Erp::Products::Property.where(name: 'Độ K').first
chu_p = Erp::Products::Property.where(name: 'Chữ').first
do_p = Erp::Products::Property.where(name: 'Độ').first
dk_p = Erp::Products::Property.where(name: 'Đường kính').first

so_vs_dok = {
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

letter_vs_do = {}
letters = ('A'..'T').to_a
('C'..'U').each do |x|
  letters << "H#{x}"
end
do_v = 0.5
letters.each do |letter|
  letter_vs_do["#{letter}"] = do_v
  do_v = do_v + 0.25
end

#lens_other = [
#  {cat: 'Premium', letter_number: 'B33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'C32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'D31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'E30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'F33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'G32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'H31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HC30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HD18', diameter: '11.4'},
#  {cat: 'Premium', letter_number: 'HD33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HE32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HF31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HG30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HH33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HI32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HJ31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HK30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HL33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HN32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HQ31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'HU30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'I30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'J33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'L31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'M30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'N33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'O32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'P31', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'Q30', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'R33', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'S32', diameter: '11.2'},
#  {cat: 'Premium', letter_number: 'T31', diameter: '11.2'},
#  {cat: 'Standard', letter_number: 'S15', diameter: '10.3'},
#  {cat: 'Standard', letter_number: 'HD15', diameter: '10.3'},
#  {cat: 'Standard', letter_number: 'Q27', diameter: '11.5'},
#  {cat: 'Standard', letter_number: 'HC24', diameter: '11.3'},
#  {cat: 'Standard', letter_number: 'HM32', diameter: '11.2'},
#  {cat: 'Standard', letter_number: 'M33', diameter: '11.2'},
#  {cat: 'GOV', letter_number: 'GOV I(+3.5)', diameter: '11.2'},
#  {cat: 'SP', letter_number: 'CTB7', diameter: '10.6'},
#  {cat: 'SP', letter_number: 'CTF7', diameter: '10.6'},
#  {cat: 'SP', letter_number: 'BTI8', diameter: '10.6'},
#  {cat: 'SP', letter_number: 'CA9 (HYBB) +0.75', diameter: '10.6'},
#  {cat: 'GOV', letter_number: 'GOV R-7', diameter: '10.4'},
#  {cat: 'Standard', letter_number: 'K24', diameter: '11'},
#  {cat: 'Standard', letter_number: 'S15', diameter: '11'},
#  {cat: 'Standard', letter_number: 'S25', diameter: '11'},
#  {cat: 'Standard', letter_number: 'HC13', diameter: '11'},
#  {cat: 'Standard', letter_number: 'HI23', diameter: '11.6'},
#  {cat: 'Standard', letter_number: 'HQ21', diameter: '11.6'},
#  {cat: 'Standard', letter_number: 'E21', diameter: '11.4'},
#  {cat: 'Standard', letter_number: 'S13', diameter: '11.4'},
#  {cat: 'Standard', letter_number: 'S15', diameter: '11.4'},
#  {cat: 'Standard', letter_number: 'HI14', diameter: '11.4'},
#  {cat: 'Standard', letter_number: 'HM19', diameter: '11.2'},
#  {cat: 'SP', letter_number: 'spH17', diameter: '11.6'},
#  {cat: 'SP', letter_number: 'spH18', diameter: '11.6'},
#  {cat: 'SP', letter_number: 'spG28', diameter: '11.2'},
#  {cat: 'SP', letter_number: 'spG29', diameter: '11.2'},
#  {cat: 'Standard', letter_number: 'HC13', diameter: '11.2'},
#  {cat: 'Standard', letter_number: 'R10', diameter: '10.2'},
#  {cat: 'Standard', letter_number: 'Q10', diameter: '10.2'},
#]
#
#lens_other.each do |row|
#  letter = row[:letter_number].scan(/\d+|[a-zA-Z]+/)[0]
#  number = row[:letter_number].scan(/\d+|[a-zA-Z]+/)[1]
#
#  cat = Erp::Products::Category.where(name: row[:cat]).first
#
#  dk_pv = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: row[:diameter]).first
#
#  chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
#  chu_pv = Erp::Products::PropertiesValue.create(property_id: chu_p.id, value: letter) if chu_pv.nil?
#
#  do_pv = Erp::Products::PropertiesValue.where(property_id: do_p.id, value: letter_vs_do[letter].to_s).first
#
#  so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: number.to_s.rjust(2, '0')).first
#  dok_pv = Erp::Products::PropertiesValue.where(property_id: dok_p.id, value: so_vs_dok[:"#{number.to_s}"]).first
#
#  create_product(user, brand, letter, number, dk_pv, cat, chu_pv, do_pv, so_pv, dok_pv, unit_cai, true)
#
#  puts "iiiiii - " + so_pv.to_json
#end










##################################### LEN Scleral #########################################################

len_cus_scl = Erp::Products::Category.where(name: "SCL").first

letters = ['SCLA', 'SCLB', 'SCLE']
letters.each do |letter|
  Erp::Products::PropertiesValue.create(
    property_id: chu_p.id,
    value: letter
  )
end

dk_pvs = Erp::Products::PropertiesValue.where(property_id: dk_p.id, value: ["16.4"])
dk_pvs.each do |dk_pv|
  letters.each do |letter|
    chu_pv = Erp::Products::PropertiesValue.where(property_id: chu_p.id, value: letter).first
    ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27"].each do |so_tmp|
      so_tmp = (["00","0"].include?(so_tmp) ? so_tmp : so_tmp.rjust(2, '0'))
      so_pv = Erp::Products::PropertiesValue.where(property_id: so_p.id, value: so_tmp).first

      if [16.4].include?(dk_pv.value.to_f) and ((['SCLA', 'SCLB'].include?(letter) and so_tmp.to_i <= 16) or ['SCLE'].include?(letter))
        create_product(user, brand, letter, so_tmp, dk_pv, len_cus_scl, chu_pv, nil, so_pv, nil, unit_cai)

        puts "==== #{dk_pv.value} #{letter} #{so_tmp} ===="
      end
    end
  end
end
