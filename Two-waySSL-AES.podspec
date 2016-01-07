Pod::Spec.new do |s|

  s.name         = "Two-waySSL-AES"
  s.version      = "0.0.2"
  s.summary      = "A useful lib for network security."
  s.description  = <<-DESC
  This one use Two-way SSL to get key for AES encryption.
  DESC

  s.homepage     = "https://github.com/w6zhou/Two-waySSL-AES"
  s.license      = "MIT"

  s.author             = { "Wenqi Zhou" => "zhou.wenqi@hotmail.com" }
  
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/w6zhou/Two-waySSL-AES.git", :tag => s.version }

  s.source_files  = 'Pod/Classes/*.{h,m}'
  s.exclude_files = "Classes/Exclude"

  s.requires_arc = true
end
