#
# Be sure to run `pod lib lint EasyAttributer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'EasyAttributer'
  s.version          = '1.0.0'
  s.summary          = 'A library that generates attributed string by matched regexes.'

  s.homepage         = 'https://github.com/sadeghgoo/EasyAttributer'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sadeghgoo' => 'sadeghitunes2@gmail.com' }
  s.source           = { :git => 'https://github.com/sadeghgoo/EasyAttributer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sadeghbt'
  s.ios.deployment_target = '11.0'
  s.source_files = 'EasyAttributer/Classes/**/*'
  s.frameworks = 'UIKit'
end
