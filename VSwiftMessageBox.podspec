#
# Be sure to run `pod lib lint VSwiftMessageBox.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VSwiftMessageBox'
  s.version          = '0.0.7'
  s.swift_version    = '5.0'
  s.summary          = 'A in-app notification/toast in swift mac application.'

  s.description      = 'A Message Box for MacOS application. Use it as in-app notification or toast.'

  s.homepage         = 'https://github.com/vong-e/VSwiftMessageBox'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vong-e' => 'sinkim123321@gmail.com' }
  s.source           = { :git => 'https://github.com/vong-e/VSwiftMessageBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform = :osx
  s.osx.deployment_target = "10.13"

  s.source_files = 'Sources/**/*.swift'

  # s.resource_bundles = {
  #   'VSwiftMessageBox' => ['VSwiftMessageBox/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  # s.dependency 'AFNetworking', '~> 2.3'
end
