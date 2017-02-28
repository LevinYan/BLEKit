Pod::Spec.new do |s|
s.name         = "LYBLEKit"
s.version      = "1.0.0"
s.summary      = "The package of useful tools, include categories and classes"
s.license      = "MIT"
s.authors      = { 'LevinYan' => '243763579@qq.com'}
s.homepage     = "https://github.com/LevinYan/BLEKit"
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/LevinYan/BLEKit.git", :tag => s.version }
s.source_files = 'BLEKit', 'BLEKit/*.{h,m}'
s.requires_arc = true
end
