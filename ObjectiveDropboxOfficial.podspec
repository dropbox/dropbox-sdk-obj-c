Pod::Spec.new do |s|
  s.name         = 'ObjectiveDropboxOfficial'
  s.version      = '3.10.0'
  s.summary      = 'Dropbox Objective C SDK for APIv2'
  s.homepage     = 'https://www.dropbox.com/developers'
  s.license      = 'MIT'
  s.author       = { 'Stephen Cobbe' => 'scobbe@dropbox.com' }
  s.source       = { :git => 'https://github.com/dropbox/dropbox-sdk-obj-c.git', :tag => s.version }
  
  s.source_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.{h,m}', 'Source/ObjectiveDropboxOfficial/Headers/**/*.h'
  s.osx.source_files =  'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/**/*.{h,m}'
  s.ios.source_files = 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/**/*.{h,m}'
  
  s.requires_arc = true
  
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '9.0'
 
  s.public_header_files = 'Source/ObjectiveDropboxOfficial/Shared/**/*.h', 'Source/ObjectiveDropboxOfficial/Headers/Umbrella/*.h'
  s.osx.public_header_files = 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_macOS/**/*.h'
  s.ios.public_header_files = 'Source/ObjectiveDropboxOfficial/Platform/ObjectiveDropboxOfficial_iOS/**/*.h'

  s.osx.frameworks = 'AppKit', 'SystemConfiguration', 'Foundation'
  s.ios.frameworks = 'UIKit', 'SafariServices', 'SystemConfiguration', 'Foundation'
end
