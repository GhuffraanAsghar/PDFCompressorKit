# PDFCompressorKit

<p align="center">
  <a href="https://cocoapods.org/pods/PDFCompressorKit">
    <img src="https://img.shields.io/cocoapods/v/PDFCompressorKit.svg" alt="CocoaPods Version">
  </a>
  <a href="https://cocoapods.org/pods/PDFCompressorKit">
    <img src="https://img.shields.io/cocoapods/p/PDFCompressorKit.svg" alt="Platform">
  </a>
  <img src="https://img.shields.io/badge/Swift-5.5%2B-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg" alt="SPM">
</p>

<p align="center">
  <b>A lightweight Swift library for PDF compression</b><br>
  <i>Works seamlessly on macOS and can be extended for iOS</i>
</p>

---

## ✨ Features

- 🍎 **Native Apple Frameworks** — Built on PDFKit & CoreGraphics
- ⚡ **Fast & Lightweight** — No third-party dependencies
- 🎚️ **Flexible Compression** — Low, Medium, High, or Custom levels
- 📊 **Progress Callbacks** — Real-time compression updates
- 🧵 **Thread Safe** — Safe for background processing
- 💾 **Multiple Input Sources** — URL, Data, or PDFDocument

---

## 📦 Installation

### CocoaPods

Add this line to your `Podfile`:

```ruby
pod 'PDFCompressorKit'
```

Then run:

```bash
pod install
```

👉 **CocoaPods page:** [https://cocoapods.org/pods/PDFCompressorKit](https://cocoapods.org/pods/PDFCompressorKit)

### Swift Package Manager (SPM)

Add **PDFCompressorKit** using Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://github.com/GhuffraanAsghar/PDFCompressorKit.git
   ```
3. Select version **0.0.1** or later

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/GhuffraanAsghar/PDFCompressorKit.git", from: "0.0.1")
]
```

---

## 🚀 Quick Start

```swift
import PDFCompressorKit

let compressor = PDFCompressor()

try compressor.compress(
    inputURL: sourceURL,
    outputURL: outputURL,
    level: .medium
)
```

---

## 📖 Usage

### Compression Levels

| Level | Quality | Scale | Best For |
|-------|---------|-------|----------|
| `.low` | High | 1.0 | Printing / Archival |
| `.medium` | Medium | 0.75 | Email / Sharing |
| `.high` | Low | 0.5 | Web / Small size |
| `.custom(quality:scale:)` | Custom | Custom | Fine control |

### Async Compression with Progress

```swift
try await compressor.compressAsync(
    inputURL: inputURL,
    outputURL: outputURL,
    level: .high
) { progress in
    print("Progress: \(Int(progress * 100))%")
}
```

### In-Memory Compression

```swift
let compressedData = try compressor.compress(
    document: pdfDocument,
    level: .medium
)
```

### Custom Compression

```swift
try compressor.compress(
    inputURL: inputURL,
    outputURL: outputURL,
    level: .custom(quality: 0.5, scale: 0.8)
)
```

### PDF Info

```swift
let info = try compressor.getPDFInfo(url: pdfURL)
print("Pages:", info["pageCount"]!)
print("Size:", info["fileSizeFormatted"]!)
```

---

## 🛠️ API Overview

### PDFCompressor

| Method | Description |
|--------|-------------|
| `compress(inputURL:outputURL:level:)` | Compress file to file |
| `compress(document:level:)` | Compress PDFDocument |
| `compress(data:level:)` | Compress PDF data |
| `compressAsync(...)` | Async compression with progress |
| `getPDFInfo(url:)` | PDF metadata |
| `estimateCompressedSize(...)` | Size estimation |

---

## 📋 Requirements

- **macOS** 11.0+
- **Swift** 5.7+
- **Xcode** 13+

---

## 📄 License

PDFCompressorKit is released under the MIT License.  
See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Pull requests are welcome.  
If you have ideas for new PDF utilities, feel free to open an issue.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/GhuffraanAsghar">Ghuffraan Asghar</a>
</p>
