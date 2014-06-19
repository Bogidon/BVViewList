Pod::Spec.new do |s|
  s.name             = "BVViewList"
  s.version          = File.read('VERSION')
  s.summary          = "Dynamically add and remove views on a custom subclass of UIScrollView."
  s.description      = <<-DESC
                      BVViewList is a simpler version of UITableView. It lets you easily add and remove views, providing subtle animations along the way. Has been tested on iOS 6.1 and 7.1. Works on both, although it is smoother on 7.1.
                       DESC
  s.homepage         = "https://github.com/Bogidon/BVViewList"
  s.license          = 'MIT'
  s.author           = { "Bogdan Vitoc" => "vitocdev@gmail.com" }
  s.platform         = :ios, '6.1'
  s.source           = { :git => "https://github.com/Bogidon/BVViewList.git", :tag => s.version.to_s }
  s.source_files = 'BVViewList/*.{h,m}'
  s.requires_arc = true
end
