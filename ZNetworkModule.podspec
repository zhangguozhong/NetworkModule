#
#  Be sure to run `pod spec lint NetworkModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZNetworkModule"
  s.version      = "1.8.1"
  s.summary      = "这是一个网络请求库，将AFNetworking封装成单例类，加入了缓存机制。"

  s.description  = <<-DESC
  这是一个网络请求库，将AFNetworking封装成单例类，加入了缓存机制，每个请求都可以设置是否开启缓存，使用方便简单。
                   DESC

  s.homepage     = "https://github.com/zhangguozhong/NetworkModule.git"
  
  s.license      = { :type => "MIT", :file => "LICENSE" }


  
  s.author             = { "zhangguozhong" => "494316382@qq.com" }
  

  # s.platform     = :ios
  s.platform     = :ios, "8.0"

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/zhangguozhong/NetworkModule.git", :tag => "#{s.version}" }
  
  s.source_files  = "NetworkModule/ZNetworkModule/**/*"



  # s.default_subspec = 'ZNetworkModule'

  # s.subspec 'ZNetworkModule' do |ZNetworkModule|
  #   ZNetworkModule.source_files = "NetworkModule/ZNetworkModule/**/*"
  # end


  # s.subspec 'Utils' do |u|
  #    u.source_files = "NetworkModule/ZNetworkModule/Utils/*.{h,m}"
  #    u.public_header_files = 'NetworkModule/ZNetworkModule/Utils/{XXAppContext,XXXRequestConfiguration}.h'

  #    u.frameworks = "UIKit", "Foundation"
  # end


  # s.subspec 'XXCache' do |c|
  #   c.dependency = "NetworkModule/ZNetworkModule/Utils"

  #   c.source_files = "NetworkModule/ZNetworkModule/XXCache/*.{h,m}"
  #   c.frameworks = "Security"

  # end

  # s.subspec 'Network' do |ss|
  #   #ss.dependency = "NetworkModule/ZNetworkModule/Utils"
  #   #ss.dependency = "NetworkModule/ZNetworkModule/XXCache"

  #   ss.source_files = "NetworkModule/ZNetworkModule/Network/**/*.{h,m}"
  #   ss.public_header_files = "NetworkModule/ZNetworkModule/Network/XXXRequest.h"
  # end

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "AFNetworking", "~> 3.0"

end
