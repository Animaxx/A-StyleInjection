
Pod::Spec.new do |s|
  s.name             = "A_StyleInjection"
  s.version          = "1.0.1"
  s.summary          = "Style Injection"
  s.description      = <<-DESC
Allow to customize whole project style without extra coding, at any moment of development life cycle
                       DESC

  s.license          = "MIT"
  s.homepage         = "https://github.com/Animaxx/A-StyleInjection"
  s.author           = { "Animax Deng" => "Animax.deng@gmail.com" }
  s.source           = { :git => "https://github.com/Animaxx/A-StyleInjection.git", :tag => "v#{s.version}" }

  s.platform         = :ios, "10.0"
  s.source_files     = "A_StyleInjection/**/*.{h,m}"
  s.requires_arc     = true
end
