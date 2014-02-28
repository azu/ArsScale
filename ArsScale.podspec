Pod::Spec.new do |s|
  s.name         = "ArsScale"
  s.version      = "0.0.2"
  s.summary      = "Porting D3.js Scales concepts to iOS."
  s.homepage     = "https://github.com/azu/ArsScale"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "azu" => "info@efcl.info" }
  s.ios.deployment_target = '6.0'
  s.source       = { 
  	:git => "https://github.com/azu/ArsScale.git",
  	:tag => s.version.to_s
  }
  s.source_files  = 'ArsScale/**/*.{h,m}'
  s.requires_arc = true
end
