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

brand = Erp::Products::Brand.where(name: "Ortho-K").first


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


def create_product(user, brand, letter, number, dk_pv, len_cat, chu_pv, do_pv, so_pv, dok_pv, unit_cai, is_outside=false)
  product = Erp::Products::Product.create(
    code: "#{chu_pv.value}#{so_pv.value}",
    name: "#{chu_pv.value}#{so_pv.value}-#{dk_pv.value}-#{len_cat.name}",
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


len_cus_scl = Erp::Products::Category.where(name: "SCL").first

letters = ['SCLC']
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

      if [16.4].include?(dk_pv.value.to_f)
        create_product(user, brand, letter, so_tmp, dk_pv, len_cus_scl, chu_pv, nil, so_pv, nil, unit_cai)

        puts "==== #{dk_pv.value} #{letter} #{so_tmp} ===="
      end
    end
  end
end
