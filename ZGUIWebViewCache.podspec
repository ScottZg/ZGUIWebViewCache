
Pod::Spec.new do |s|



  s.name         = "ZGUIWebViewCache"
  s.version      = "1.0.0"
  s.summary      = "UIWebView cache"

  s.description  = <<-DESC
                  using for cache h5 with type your choose
                   DESC

  s.homepage     = "https://github.com/ScottZg/ZGUIWebViewCache"

  s.license      = "MIT"


  s.author             = { "zhanggui" => "scottzg@126.com" }
  

  s.ios.deployment_target = "6.0"
 

  s.source       = { :git => "https://github.com/ScottZg/ZGUIWebViewCache.git", :tag => "#{s.version}" }

  s.source_files  = "ZGUIWebViewCache/ZGUIWebViewCache/*.{h,m}"


 


end
