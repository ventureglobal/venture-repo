# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'koozeh-ios' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  # Pods for koozeh-ios

pod 'Mantle'
pod 'Realm'
pod 'AFNetworking'
pod 'SDWebImage'
pod 'LGPlusButtonsView', '~> 1.1.0'
pod 'MaterialShowcase'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name.include?('MaterialShowcase')
        target.build_configurations.each do |config|
           config.build_settings['SWIFT_VERSION'] = '3.2'
        end
      end
    end
  end

  target 'koozeh-iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'koozeh-iosUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
