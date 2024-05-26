platform :ios, '13.0'
source 'https://github.com/CocoaPods/Specs.git'

target 'LoopWalk' do
  use_frameworks!

  pod 'MapboxMaps', '~> 10.7.0'
  pod 'Turf'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end

