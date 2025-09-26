#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint audio_converter_native.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'audio_converter_native'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for native audio conversion using Platform Channels.'
  s.description      = <<-DESC
A Flutter package for native audio conversion using Platform Channels. Supports real audio conversion on Android and iOS without external dependencies.
                       DESC
  s.homepage         = 'https://github.com/yourusername/audio_converter_native'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
