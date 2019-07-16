source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

def shared_pods
    pod 'OneSignal', '>= 2.5.2', '< 3.0'
end

target 'R6-Plus' do
    pod 'Alamofire'
    pod 'Kingfisher'
    pod 'Google-Mobile-Ads-SDK'
    pod 'Firebase/Core'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'RxSwift'
    pod 'RxCocoa'
    shared_pods
end

target 'OneSignalNotificationServiceExtension' do
    shared_pods
end
