# PDFCompressorKit

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2013%2B%20%7C%20macOS%2010.15%2B-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/SPM-Compatible-brightgreen.svg" alt="SPM">
</p>

<p align="center">
  <b>A powerful, cross-platform Swift package for PDF compression</b><br>
  <i>Works seamlessly on both iOS (UIKit) and macOS (AppKit)</i>
</p>

---

## ✨ Features

- 🍎 **Cross-Platform** - Works on iOS 13+ and macOS 10.15+
- ⚡ **Async Support** - Modern Swift concurrency with progress tracking
- 🎚️ **Flexible Compression** - Low, Medium, High, or Custom levels
- 📊 **Progress Callbacks** - Real-time compression progress updates
- 🧵 **Thread Safe** - Built with `Sendable` conformance
- 💾 **Multiple Input Sources** - Compress from URL, Data, or PDFDocument

---

## 📦 Installation

### Swift Package Manager

Add **PDFCompressorKit** to your project using Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL:
   ```
   https://github.com/YOUR_USERNAME/PDFCompressorKit.git
   ```
3. Select version **1.0.0** or later

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/YOUR_USERNAME/PDFCompressorKit.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: ["PDFCompressorKit"]
    )
]
```

---

## 🚀 Quick Start

```swift
import PDFCompressorKit

let compressor = PDFCompressor()

// Simple compression
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
| `.low` | 90% | 100% | Archival, printing |
| `.medium` | 60% | 75% | Email, sharing |
| `.high` | 30% | 50% | Web, maximum compression |
| `.custom(quality:scale:)` | Custom | Custom | Fine-grained control |

### Basic Compression

```swift
import PDFCompressorKit

let compressor = PDFCompressor()

do {
    try compressor.compress(
        inputURL: inputURL,
        outputURL: outputURL,
        level: .medium
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

### Custom Compression Settings

```swift
// 50% JPEG quality, 80% resolution
try compressor.compress(
    inputURL: inputURL,
    outputURL: outputURL,
    level: .custom(quality: 0.5, scale: 0.8)
)
```

### Get PDF Information

```swift
let info = try compressor.getPDFInfo(url: pdfURL)
print("📄 Pages: \(info["pageCount"]!)")
print("💾 Size: \(info["fileSizeFormatted"]!)")
```

---

## 🎯 Real-World Example

### iOS/macOS App Integration

```swift
import SwiftUI
import PDFCompressorKit

struct ContentView: View {
    @State private var progress: Double = 0
    @State private var isCompressing = false
    
    var body: some View {
        VStack {
            if isCompressing {
                ProgressView(value: progress)
                    .padding()
                Text("\(Int(progress * 100))%")
            }
            
            Button("Compress PDF") {
                Task {
                    await compressPDF()
                }
            }
            .disabled(isCompressing)
        }
    }
    
    func compressPDF() async {
        isCompressing = true
        let compressor = PDFCompressor()
        
        do {
            try await compressor.compressAsync(
                inputURL: inputURL,
                outputURL: outputURL,
                level: .medium
            ) { prog in
                Task { @MainActor in
                    progress = prog
                }
            }
        } catch {
            print("Error: \(error)")
        }
        
        isCompressing = false
    }
}
```

---

## 🛠️ API Reference

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
- **Swift** 5.9+
- **Xcode** 15.0+

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
