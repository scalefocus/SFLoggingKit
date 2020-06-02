Pod::Spec.new do |s|
  s.name             = 'SFLoggingKit'
  s.version          = '2.0.0'
  s.summary          = 'LoggingKit handles logging for various LogLevels'
  s.description      = <<-DESC
TODO: LoggingKit handles logging for various LogLevels Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/scalefocus/SFLoggingKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Scalefocus' => 'code@upnetix.com' }
  s.source           = { :git => 'https://github.com/scalefocus/SFLoggingKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'SFLoggingKit/Classes/**/*'
  
end
