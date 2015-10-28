Pod::Spec.new do |s|
  s.name             = "APCoreDataViewControllers"
  s.version          = "0.1.1"
  s.summary          = "Few helper classes to present CoreData objects via UIViewControllers"
  s.homepage         = "https://github.com/flavionegrao/APCoreDataViewControllers"
  s.license          = 'MIT'
  s.author           = { "Flavio Negrao Torres" => "flavio@apetis.com" }

  s.source           = { :git => "https://github.com/flavionegrao/APCoreDataViewControllers.git", :tag => "#{s.version}" }
  s.source_files     = "APCoreDataViewControllers/**"

  s.framework  = 'CoreData'
  s.ios.deployment_target = '6.0'
  s.requires_arc = true

end

