$:.push File.expand_path('../lib', __FILE__)
require 'erp/products/version'
Gem::Specification.new do |s|
  s.name        = 'erp_products'
  s.version     = Erp::Products::VERSION
  s.authors     = ['Công Ty TNHH Giải Pháp CNTT Và Truyền Thông Hoàng Khang']
  s.email       = ['kinhdoanh@hoangkhang.com.vn']
  s.homepage    = 'https://timhangcongnghe.com/'
  s.summary     = 'Tìm Hàng Công Nghệ'
  s.description = 'Tìm Hàng Công Nghệ là đơn vị cung cấp các sản phẩm, dịch vụ thuộc lĩnh vực Công Nghệ Thông Tin do Công Ty TNHH Giải Pháp CNTT Và Truyền Thông Hoàng Khang phụ trách và phát triển.'
  s.license     = 'MIT'
  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']
  s.add_dependency 'rails'
  s.add_dependency 'erp_core'
  s.add_dependency 'deface'
end