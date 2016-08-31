Pod::Spec.new do |s|
  s.name         = "ObjectiveDropboxOfficial"
  s.version      = "1.0.0"
  s.summary      = "Dropbox Objective C SDK for APIv2"
  s.homepage     = "https://dropbox.com/developers/"
  s.license      = "MIT"
  s.author       = { "Stephen Cobbe" => "scobbe@dropbox.com" }
  s.source    = { :git => "https://github.com/dropbox/<placeholder>.git", :tag => s.version }
  s.osx.source_files = 'Source/PlatformNeutral/**/*.{h,m}', 'Source/PlatformDependent/OSX/*.{h,m}'
  s.ios.source_files = 'Source/PlatformNeutral/**/*.{h,m}', 'Source/PlatformDependent/iOS/*.{h,m}'
  s.requires_arc = true
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "8.0"
  s.public_header_files = 'Source/**/*.h'
  s.osx.frameworks = 'AppKit', 'Foundation'
  s.ios.frameworks = 'UIKit', 'Webkit', 'Foundation'
end