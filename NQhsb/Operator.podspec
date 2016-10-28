Pod::Spec.new do |s|
  s.name         = 'Operator'
  s.version      = '<#Project Version#>'
  s.license      = '<#License#>'
  s.homepage     = '<#Homepage URL#>'
  s.authors      = '<#Author Name#>': '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  git: '<#Github Repo URL#>', :tag => s.version
  s.source_files = '<#Resources#>'
  s.frameworks   =  '<#Required Frameworks#>'
  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod 'Masonry', '~> 1.0.1'
  s.dependencies =	pod 'AFNetworking', '~> 3.1.0'
  s.dependencies =	pod 'MJExtension', '~> 3.0.10'
  s.dependencies =	pod 'MBProgressHUD', '~> 0.9.2'
  s.dependencies =	pod 'SDWebImage', '~> 3.7.5'
  s.dependencies =	pod 'MJRefresh', '~> 3.1.0'
  s.dependencies =	pod 'SDCycleScrollView', '~> 1.64'#轮播器
  s.dependencies =	pod 'IQKeyboardManager'#用于键盘管理
  s.dependencies =	pod 'GJCFUitils'#各种常用宏的集合
  s.dependencies =	pod 'JPush-iOS-SDK', '~> 2.1.7'
  s.dependencies =	pod 'UMengSocialCOM', '~> 5.2.1'
  s.dependencies =	pod 'SDCycleScrollView','~> 1.64'
  s.dependencies =	pod 'CocoaAsyncSocket', '~> 7.4.3'
  s.dependencies =	pod 'TZImagePickerController', '~> 1.4.4'

end