# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Ronaldo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ronaldo
  pod 'RxSwift'
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'MBProgressHUD'  
  pod 'XLPagerTabStrip'
  # pod 'RealmSwift'
  pod 'SnapKit'
  pod 'SQLite.swift', '~> 0.13.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'MBProgressHUD'
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end


# post_install do |installer|
#   installer.pods_project.build_configurations.each do |config|
#    config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
#  end
#end
