source 'https://github.com/CocoaPods/Specs.git'

platform :ios, "8.0"
use_frameworks!

target 'QuestionsApp' do
    pod 'Alamofire'
    pod 'SpeedLog'
    pod 'StatefulViewController'
    pod 'JLToast'
    pod 'Google/Analytics'
    pod 'Nuke'
    pod 'iRate'
    pod 'ChameleonFramework/Swift'
    pod 'Spring',:git => 'https://github.com/tpae/Spring.git', :branch => 'swift-2.3-migration'
    pod 'SwiftyJSON', :git => 'https://github.com/rpowelll/SwiftyJSON.git', :tag => 'swift-2.3'
    pod 'AlamofireObjectMapper', '~> 3.0'
    # pod 'PullToBounce'
    pod 'DGElasticPullToRefresh', :git => 'https://github.com/hungdt8/DGElasticPullToRefresh.git', :tag => 'cocoapods'
    pod 'MBProgressHUD', '~> 1.0'
    pod 'MagicalRecord', '~> 2.3'
    pod 'iosMath'
    
    pod 'Google/Analytics'
    #pod 'Firebase/Core'

end


post_install do |installer| 
  installer.pods_project.targets.each  do |target| 
      target.build_configurations.each  do |config| config.build_settings['SWIFT_VERSION'] = ‘2.3’ 
      end 
   end 
end
