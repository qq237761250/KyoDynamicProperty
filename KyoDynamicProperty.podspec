#
# Be sure to run `pod lib lint KyoDynamicProperty.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KyoDynamicProperty'
  s.version          = '0.0.1'
  s.summary          = 'A short description of KyoDynamicProperty.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/qq237761250/KyoDynamicProperty'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kyo' => '237761250@qq.com' }
  s.source           = { :git => 'https://github.com/qq237761250/KyoDynamicProperty.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'KyoDynamicProperty/**/*.{swift,h,m}'
  
  # s.resource_bundles = {
  #   'KyoDynamicProperty' => ['KyoDynamicProperty/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
