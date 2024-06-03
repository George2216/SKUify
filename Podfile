# Uncomment the next line to define a global platform for your project
source 'https://cdn.cocoapods.org/'
platform :ios, '16.2'
inhibit_all_warnings!
install! 'cocoapods',
 :warn_for_unused_master_specs_repo => false

def rx_swift
    pod 'RxRelay'
    pod 'RxDataSources'
    pod 'RxCocoa'
    pod 'RxSwift'
end

def test_pods
    pod 'RxTest', '~> 6.5.0'
    pod 'RxBlocking', '~> 6.5.0'
    pod 'Nimble'
end

target 'InAppPurchasesPlatform' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
# Pods for InAppPurchasesPlatform

  target 'InAppPurchasesPlatformTests' do
    # Pods for testing
  end

end


target 'SKUify' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  rx_swift
  pod 'SnapKit'
  pod 'DGCharts'
  pod 'SwifterSwift'
  pod 'FSCalendar'
  pod 'SDWebImage'
  pod 'Kingfisher'
  
  target 'SKUifyTests' do
    inherit! :search_paths
    test_pods
  end

  target 'SKUifyUITests' do
    test_pods
  end

end


target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  pod 'Alamofire'

  target 'DomainTests' do
    inherit! :search_paths
    test_pods
  end

end

target 'NetworkPlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    rx_swift
    pod 'Alamofire'
    pod 'RxAlamofire'

    target 'NetworkPlatformTests' do
        inherit! :search_paths
        test_pods
    end
    
end

target 'RealmPlatform' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  pod 'RxRealm'
  pod 'QueryKit'
  pod 'RealmSwift'
  pod 'Realm'

  target 'RealmPlatformTests' do
    inherit! :search_paths
    test_pods
  end

end

target 'RxExtensions' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift


  target 'RxExtensionsTests' do
    inherit! :search_paths
    test_pods
  end
  
  
  target 'AppEventsPlatform' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    rx_swift
 

  end


end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.2'
            end
        end
    end
end
