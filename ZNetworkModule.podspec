#
#  Be sure to run `pod spec lint NetworkModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZNetworkModule"
  s.version      = "1.8.2"
  s.summary      = "这是一个网络请求库，将AFNetworking封装成单例类，加入了缓存机制。"

  s.description  = <<-DESC
  这是一个网络请求库，将AFNetworking封装成单例类，加入了缓存机制，每个请求都可以设置是否开启缓存，使用方便简单。
                   DESC

  s.homepage     = "https://github.com/zhangguozhong/NetworkModule.git"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "zhangguozhong" => "494316382@qq.com" }
  

  # s.platform     = :ios
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  

  s.source       = { :git => "https://github.com/zhangguozhong/NetworkModule.git", :tag => "#{s.version}" }
  #s.source_files  = "NetworkModule/ZNetworkModule/**/*"
  s.requires_arc = true

  
  #s.default_subspec = 'Classes'


  # s.subspec 'Classes' do |networkModule|
  #   networkModule.dependency = 'NetworkModule/ZNetworkModule/Utils'
  #   networkModule.dependency = 'NetworkModule/ZNetworkModule/XXCache'
  #   networkModule.dependency = 'NetworkModule/ZNetworkModule/Network'
  #   networkModule.dependency "AFNetworking", "~> 3.0"
  # end

  #私有库
  s.subspec 'Utils' do |utils|
     utils.source_files = "NetworkModule/ZNetworkModule/Utils/**/*.{h,m}"
  end

  s.subspec 'XXCache' do |cache|
    cache.source_files = "NetworkModule/ZNetworkModule/XXCache/**/*.{h,m}"
    cache.dependency = 'ZNetworkModule/Utils'
    cache.frameworks = 'Security'
  end

  s.subspec 'Network' do |network|
     network.source_files = "NetworkModule/ZNetworkModule/Network/**/*.{h,m}"
     network.dependency = 'ZNetworkModule/Utils'
     network.dependency = 'ZNetworkModule/XXCache'
  end


  s.dependency "AFNetworking", "~> 3.0"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
