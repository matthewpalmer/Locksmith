Pod::Spec.new do |s|
  s.name             = "Locksmith"
  s.version          = "2.0.1"
  s.summary          = "Locksmith is a protocol-oriented way to work with the iOS Keychain in Swift."
  s.description      = <<-DESC
                       Locksmith is a protocol-oriented way to work with the iOS Keychain in Swift. It provides extensive support for a lot of different keychain requests, and extensively uses Swift-native concepts.
                       DESC
  s.homepage         = "https://github.com/matthewpalmer/Locksmith"
  s.license          = 'MIT'
  s.author           = { "matthewpalmer" => "matt@matthewpalmer.net" }
  s.source           = { :git => "https://github.com/matthewpalmer/Locksmith.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/_matthewpalmer'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'Source/*.{m,h,swift}'

  s.frameworks = 'Foundation', 'Security'
end
