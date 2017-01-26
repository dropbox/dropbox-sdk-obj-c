Pod::Spec.new do |s|
  s.name         = 'ObjectiveDropboxOfficial'
  s.version      = '2.0.6'
  s.summary      = 'Dropbox Objective C SDK for APIv2'
  s.homepage     = 'https://dropbox.com/developers/'
  s.license      = 'MIT'
  s.author       = { 'Stephen Cobbe' => 'scobbe@dropbox.com' }
  s.source       = { :git => 'https://github.com/dropbox/dropbox-sdk-obj-c.git', :tag => s.version }
  
  s.osx.source_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.{h,m}', 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/**/*.{h,m}', 'Source/ObjectiveDropboxOfficial/Headers/*.h'
  s.ios.source_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.{h,m}', 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/**/*.{h,m}', 'Source/ObjectiveDropboxOfficial/Headers/*.h'
  
  s.requires_arc = true
  
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
 
  s.osx.public_header_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.h', 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/**/*.h', 'Source/ObjectiveDropboxOfficial/Headers/*.h'
  s.ios.public_header_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.h', 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/**/*.h', 'Source/ObjectiveDropboxOfficial/Headers/*.h'
  
  s.osx.frameworks = 'AppKit', 'WebKit', 'SystemConfiguration', 'Foundation'
  s.ios.frameworks = 'UIKit', 'WebKit', 'SystemConfiguration', 'Foundation'
end
