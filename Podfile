# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
inhibit_all_warnings!

source "https://github.com/CocoaPods/Specs.git"

target 'Example' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Masonry'
  pod 'ReactiveObjC'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxRelay'
  # Pods for Example

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
