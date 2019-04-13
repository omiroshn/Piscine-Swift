Pod::Spec.new do |s|
  s.name             = 'omiroshn2019'
  s.version          = '1.0.4'
  s.summary          = 'This is such a omiroshn Framework.'
  s.description      = 'This is some super omiroshn framework made by one crazy guy.'
  s.homepage         = 'https://github.com/omiroshn/omiroshn2019'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'omiroshn' => 'omiroshn@student.unit.ua' }
  s.source           = { :git => 'https://github.com/omiroshn/omiroshn2019.git', :tag => '1.0.4' }
  s.social_media_url = 'https://twitter.com/Farvakl'
  
  s.ios.deployment_target = '10.0'
  
  s.resources    = 'omiroshn2019/Assets/**/*.xcdatamodeld'
  s.source_files = 'omiroshn2019/Classes/**/*.swift'
  
#  s.resource_bundles = {
#    'omiroshn2019' => ['omiroshn2019/Assets/**/*.xcdatamodeld']
#  }
  s.frameworks = 'Coredata'
end
