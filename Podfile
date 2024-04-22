# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KFU-IT-Support' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit', '~> 5.6.0'
  pod 'SwiftGen', '~> 6.0'
  pod 'SwiftLint'
  pod 'SkeletonView'
  pod 'Moya', '~> 15.0'
  pod 'FirebaseAnalytics'
  pod 'Swinject'
  pod "LetterAvatarKit", "1.2.5"
  pod 'KeychainSwift', '~> 22.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end

end
