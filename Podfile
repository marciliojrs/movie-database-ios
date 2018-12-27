source 'https://github.com/CocoaPods/Specs'

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Sourcery', '~> 0.15'
  pod 'SwiftyBeaver'
end

def test_pods
  pod 'Fakery', '~> 3.4'
end

target 'MovieDatabase' do
  shared_pods
  pod 'R.swift', '5.0.0.alpha.2'
  pod 'Kingfisher', '~> 4.10.0'
  pod 'URLNavigator'
  pod 'Crashlytics', '~> 3.11'

  target 'Tests' do
    inherit! :search_paths
    test_pods
    pod 'URLNavigator'
  end
end

target 'Domain' do
  shared_pods

  target 'DomainTests' do
    inherit! :search_paths    
    test_pods
  end
end

target 'RestApiProvider' do
  shared_pods

  target 'RestApiProviderTests' do
    inherit! :search_paths    
    test_pods
  end
end
