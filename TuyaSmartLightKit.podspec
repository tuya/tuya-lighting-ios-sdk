Pod::Spec.new do |s|
  s.name = "TuyaSmartLightKit"
  s.version = "0.1.0"
  s.summary = "Tuya Smart Light Kit for iOS"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"Tuya SDK"=>"developer@tuya.com"}
  s.homepage = "https://developer.tuya.com/"
  s.frameworks = ["UIKit", "Foundation"]
  s.source = { :git => 'https://github.com/TuyaInc/tuyasmart_lighting_ios_sdk.git', :tag => s.version.to_s}
  s.static_framework = true
  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'TuyaSmartLightKit.framework'
  
  s.dependency 'TuyaSmartDeviceCoreKit', '>=3.20.0'
end
