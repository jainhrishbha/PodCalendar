Pod::Spec.new do |spec|

  spec.platform = :ios
  spec.ios.deployment_target = '11.0'
  spec.name         = "PodCalendar"
  spec.version      = "0.0.1"
  spec.summary      = "Adding Calendar to your iOS app."

 

  spec.homepage     = "https://github.com/jainhrishbha/PodCalendar"
  

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  
  spec.author             = { "Hrishbha Jain" => "hrishbhajain@magenative.com" }
  
  


 
  spec.source       = { :git => "https://github.com/jainhrishbha/PodCalendar.git", :tag => "#{spec.version}" }

    spec.static_framework = true
    spec.framework = "UIKit"
    spec.dependency 'DropDown'
    spec.source_files  = "PodCalendar/**/*.{h,m,swift}"
  

   spec.swift_version = "5.0"
  
   spec.requires_arc = true

  

end
