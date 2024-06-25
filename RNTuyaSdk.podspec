require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNTuyaSdk"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platforms    = { :ios => "12.4" }

  s.source       = { :git => "https://github.com/HisenseLtd/react-native-tuya.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m}"

  s.dependency 'React'
  s.dependency 'ThingSmartHomeKit'
  s.dependency 'YYModel'
end
