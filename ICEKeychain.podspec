Pod::Spec.new do |s|
s.name             = 'ICEKeychain'
s.version          = '1.0.0'
s.summary          = '钥匙串存取密码的封装'
s.description      = <<-DESC
TODO: 封装用户名和密码存取钥匙串的方法
DESC

s.homepage         = 'https://github.com/My-Pod/ICEKeychain'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'gumengxiao' => 'rare_ice@163.com' }
s.source           = { :git => 'https://github.com/My-Pod/ICEKeychain.git', :tag => s.version.to_s }

s.ios.deployment_target = '7.0'
s.source_files = 'Classes/*.{h,m}'
ss.frameworks = 'Security'

end
