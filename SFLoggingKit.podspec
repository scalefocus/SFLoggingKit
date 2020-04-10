#
# Be sure to run `pod lib lint LoggingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFLoggingKit'
  s.version          = '1.0.2'
  s.summary          = 'LoggingKit handles logging for various LogLevels'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: LoggingKit handles logging for various LogLevels Add long description of the pod here.
                       DESC

  s.homepage         = 'https://bitbucket.upnetix.com/projects/IL/repos/upnetix-logging-kit-pod/browse'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Martin Vasilev' => 'martin.vasilev@upnetix.com' }
  s.source           = { :git => 'https://bitbucket.upnetix.com/scm/il/upnetix-logging-kit-pod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'

  s.source_files = 'SFLoggingKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LoggingKit' => ['LoggingKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
