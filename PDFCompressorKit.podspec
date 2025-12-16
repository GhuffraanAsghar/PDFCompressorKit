Pod::Spec.new do |spec|

  spec.name         = "PDFCompressorKit"
  spec.version      = "0.0.1"

  spec.summary      = "A lightweight Swift library for compressing PDF files on macOS using native Apple frameworks."

  spec.description  = <<-DESC
PDFCompressorKit is a simple and efficient Swift library designed to compress PDF files on macOS.
It uses native Apple frameworks such as PDFKit and CoreGraphics to reduce file size
while maintaining good visual quality. Ideal for document-based macOS applications.
  DESC

  spec.homepage     = "https://github.com/GhuffraanAsghar/PDFCompressorKit"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Ghuffran Asghar" => "ghuffranasghar@gmail.com" }

  spec.source       = {
    :git => "https://github.com/GhuffraanAsghar/PDFCompressorKit.git",
    :tag => spec.version.to_s
  }

  spec.platform     = :osx, "11.0"
  spec.swift_version = "5.7"

  spec.source_files = "Sources/PDFCompressorKit/**/*.swift"

  spec.frameworks = "PDFKit", "Foundation", "CoreGraphics"

end
