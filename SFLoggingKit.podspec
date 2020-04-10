#
# Be sure to run `pod lib lint LoggingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFLoggingKit'
  s.version          = '2.0.0'
  s.summary          = 'SFLoggingKit handles logging for various LogLevels'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: SFLoggingKit handles logging for various LogLevels Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/scalefocus/SFLoggingKit'
  s.screenshots      = 'https://user-images.githubusercontent.com/7243597/78951156-c8963300-7ad9-11ea-831c-949ab8fbd564.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Scalefocus' => 'code@upnetix.com' }
  s.source           = { :git => 'https://github.com/scalefocus/SFLoggingKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'

  s.source_files = 'SFLoggingKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFLoggingKit' => ['SFLoggingKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
