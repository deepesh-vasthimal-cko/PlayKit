Pod::Spec.new do |s|
  s.name         = "PlayKit"
  s.version      = "1.0.3"
  s.summary      = "iOS XCFramework Containing pod spec config"
  s.description  = <<-DESC
  iOS XCFramework Containing pod spec config
                   DESC
  s.homepage     = "https://www.google.com"
  s.swift_version = "5.0"
  s.license      = <<-DESC
                   DESC
  s.author       = { "Deepesh" => "deepesh" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/deepesh-vasthimal-cko/PlayKit.git", :tag => "#{s.version}" }

  s.vendored_frameworks = "PlayKit.xcframework"

  s.dependency 'JOSESwift', '2.2.1'

  s.user_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    'VALID_ARCHS' => 'arm64 x86_64'
  }
end
