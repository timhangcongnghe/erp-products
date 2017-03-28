user = Erp::User.first
(0..50).each do |cat|
  category = Erp::Products::Category.create(name: "Main category"+cat.to_s, creator_id: user.id)
end
(0..50).each do |unit|
  unit = Erp::Products::Unit.create(name: "Cái"+unit.to_s, creator_id: user.id)
end
(0..50).each do |product|
  Erp::Products::Product.create(
    code: 'P000'+product.to_s,
    name: 'Sweet Cake Love'+product.to_s,
    category_id: Erp::Products::Category.all.map(&:id).sample,
    creator_id: user.id,
    price: 120000,
    cost: 950000,
    unit_id: Erp::Products::Unit.all.map(&:id).sample,
    short_description: "<p><strong>M&agrave;n h&igrave;nh:</strong> 14&rdquo;, 1366x768</p>
<p><strong>CPU:</strong> Intel Celeron, 1.6GHz</p>
<p><strong>RAM:</strong> 4GB / <strong>HDD:</strong> 500GB</p>
<p><strong>VGA:</strong> Intel HD Graphics</p>
<p><strong>HĐH:</strong> Windows 10 Home</p>
<p><strong>Pin:</strong> 3 cell / <strong>DVD:</strong> Kh&ocirc;ng</p>"
  )
end