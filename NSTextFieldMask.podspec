Pod::Spec.new do |s|


  s.name         = "NSTextFieldMask"
  s.version      = "1.0.0"
  s.summary      = "NSTextFieldMask is a subclass of UILabel what allow to use placehilder as mask"

  s.description  = <<-DESC
                   A longer description of NSTextFieldMask in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/andriitishchenko/NSTextFieldMask"
  s.screenshots  = "https://camo.githubusercontent.com/6d21bea19d21f4cc4dd95429bcc6e74b2178fd9a/68747470733a2f2f7261772e6769746875622e636f6d2f616e64726969746973686368656e6b6f2f4e53546578744669656c644d61736b2f6d61737465722f64656d6f496d6167652e706e67"

  s.license      = { :type => "MIT", :file => "LICENSE" }


  
  s.author             = { "Andrii Tishchenko" => "andrii.tishchenko+github@gmail.com" }


  s.platform     = :ios
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/andriitishchenko/NSTextFieldMask.git", :tag => "v#{s.version.to_s}" }

  s.source_files  = "NSTextFieldMask/**/*.{h,m}"
  s.exclude_files = "NSTextFieldMaskDemo"
  s.public_headers_files = "NSTextFieldMask/*.h"

  s.requires_arc = true

end
