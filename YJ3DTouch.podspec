

Pod::Spec.new do |s|
  s.name         = "YJ3DTouch"
  s.version      = "1.1.1"
  s.summary      = "Adapt very easily to 3D Touch."
  s.description  = <<-DESC
  YJ3DTouch can easily implement 3D Touch.
                   DESC

  s.homepage     = "https://github.com/Hyman00/YJ3DTouch"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Hyman00" => "skongoo@163.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Hyman00/YJ3DTouch.git", :tag => "#{s.version}" }


  s.source_files  = "YJ3DTouch", "YJ3DTouch/**/*.{h,m}"
  
  s.requires_arc = true

end
