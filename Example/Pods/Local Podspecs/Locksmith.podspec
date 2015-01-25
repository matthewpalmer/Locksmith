#
# Be sure to run `pod lib lint Locksmith.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Locksmith"
  s.version          = "1.1.0"
  s.summary          = "Locksmith is a sane way to work with the iOS Keychain in Swift."
  s.description      = <<-DESC
                       Locksmith is a sane way to work with the iOS Keychain in Swift.
                       It provides a fast and intuitive way to work with the C Keychain API.
                       Results are provided as tuples, and errors are informative and easily detected.
                       DESC
  s.homepage         = "https://github.com/matthewpalmer/Locksmith"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "matthewpalmer" => "matt@matthewpalmer.net" }
  s.source           = { :git => "https://github.com/matthewpalmer/Locksmith.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_matthewpalmer'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'Locksmith' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
