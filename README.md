# PDFCompressorKit

<p align="center">
  <a href="https://cocoapods.org/pods/PDFCompressorKit">
    <img src="https://img.shields.io/cocoapods/v/PDFCompressorKit.svg" alt="CocoaPods Version">
  </a>
  <img src="https://img.shields.io/badge/Platform-iOS%2013%2B%20%7C%20macOS%2010.15%2B-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-5.5%2B-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg" alt="SPM">
</p>

<p align="center">
  <b>A powerful, cross-platform Swift package for PDF compression</b><br>
  <i>Works seamlessly on both iOS (UIKit) and macOS (AppKit)</i>
</p>

---

## ✨ Features

- 👶 **Extremely Easy to Use** — Compress a PDF in just one line of code!
- 🍎 **Cross-Platform** — Works natively on iOS 13+ and macOS 10.15+
- 🧠 **Smart Text Detection** — Preserves crisp vector text without blurring
- 🖼️ **Optimal HEIC Compression** — Keeps image quality the same while halving the file size
- ⚡ **Async Support** — Modern Swift concurrency with progress tracking
- 🎚️ **Flexible Compression** — Optimal, Low, Medium, High, or Custom levels
- 📊 **Progress Callbacks** — Real-time compression progress updates
- 🧵 **Thread Safe** — Safe for use across multiple threads
- 💾 **Multiple Input Sources** — Compress from URL, Data, or PDFDocument

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

Add **PDFCompressorKit** to your project using Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://github.com/GhuffraanAsghar/PDFCompressorKit.git
   ```
3. Select version **1.2.0** or later

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/GhuffraanAsghar/PDFCompressorKit.git", from: "1.2.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["PDFCompressorKit"]
    )
]
```

---

## 🚀 Quick Start (New Simple API)

It is now incredibly easy to compress a PDF. You can do it in literally one line of code using our `URL` extensions:

```swift
import PDFCompressorKit

// Overwrite the existing file with optimal compression
try inputURL.compressPDF() 

// Save the compressed PDF to a new location
try inputURL.compressPDF(to: outputURL)

// Or specify a different compression level
try inputURL.compressPDF(level: .medium)
```

---

## 📖 Advanced Usage

### Compression Levels

| Level | Quality | Scale | Best For |
|-------|---------|-------|----------|
| `.optimal` | 80% (HEIC) | 100% | Keep quality identical, halve file size |
| `.low` | 90% | 100% | Archival, printing |
| `.medium` | 60% | 75% | Email, sharing |
| `.high` | 30% | 50% | Web, maximum compression |
| `.custom(quality:scale:)` | Custom | Custom | Fine-grained control |

### Using PDFCompressor Explicitly

```swift
import PDFCompressorKit

let compressor = PDFCompressor()

do {
    try compressor.compress(
        inputURL: inputURL,
        outputURL: outputURL,
        level: .optimal
    )
    print("✅ Compression complete!")
} catch {
    print("❌ Error: \(error.localizedDescription)")
}
```

### Async Compression with Progress

```swift
try await compressor.compressAsync(
    inputURL: inputURL,
    outputURL: outputURL,
    level: .high
) { progress in
    // Update your UI
    print("Progress: \(Int(progress * 100))%")
}
```

### In-Memory Compression

```swift
// From PDFDocument
let compressedData = try compressor.compress(
    document: pdfDocument,
    level: .medium
)

// From Data
let compressedData = try compressor.compress(
    data: pdfData,
    level: .high
)
```

### Get PDF Information

```swift
let info = try compressor.getPDFInfo(url: pdfURL)
print("📄 Pages: \(info["pageCount"]!)")
print("💾 Size: \(info["fileSizeFormatted"]!)")
```

---

## 🛠️ API Reference

### URL Extension (Simplest API)

| Method | Description |
|--------|-------------|
| `compressPDF(to:level:)` | Compress PDF file |
| `compressPDFAsync(to:level:progress:)` | Async file compression with progress |

### PDFCompressor

| Method | Description |
|--------|-------------|
| `compress(inputURL:outputURL:level:)` | Compress file to file |
| `compress(document:level:)` | Compress PDFDocument, returns Data |
| `compress(data:level:)` | Compress PDF data, returns Data |
| `compressAsync(inputURL:outputURL:level:progress:)` | Async file compression with progress |
| `compressAsync(document:level:progress:)` | Async document compression with progress |
| `getPDFInfo(url:)` | Get page count and file size |
| `estimateCompressedSize(inputURL:level:)` | Estimate final size |

### PDFCompressorError

| Error | Description |
|-------|-------------|
| `.invalidPDF` | Input PDF cannot be read |
| `.cannotCreateOutput` | Output file creation failed |
| `.compressionFailed` | Compression processing error |
| `.fileNotFound` | Input file not found |

---

## 📋 Requirements

- **iOS** 13.0+
- **macOS** 10.15+
- **Swift** 5.5+
- **Xcode** 13.0+

---

## 📄 License

PDFCompressorKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/GhuffraanAsghar">Ghuffraan Asghar</a>
</p>
