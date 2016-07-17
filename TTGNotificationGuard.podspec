Pod::Spec.new do |s|
  s.name             = 'TTGNotificationGuard'
  s.version          = '0.1.1'
  s.summary          = 'Auto remove the observer from NSNotificationCenter after the oberser dealloc.'

  s.description      = <<-DESC
                        Auto remove the observer from NSNotificationCenter after the oberser dealloc, base on TTGDeallocTaskHelper.
                       DESC

  s.homepage         = 'https://github.com/zekunyan/TTGNotificationGuard'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zekunyan' => 'zekunyan@163.com' }
  s.source           = { :git => 'https://github.com/zekunyan/TTGNotificationGuard.git', :tag => s.version.to_s }
  s.social_media_url = 'http://tutuge.me'

  s.ios.deployment_target = '6.0'
  s.platform = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'TTGNotificationGuard/Classes/**'
  s.public_header_files = 'TTGNotificationGuard/Classes/*.h'

  s.frameworks = 'UIKit', 'CoreFoundation'
  s.dependency 'TTGDeallocTaskHelper'
end
