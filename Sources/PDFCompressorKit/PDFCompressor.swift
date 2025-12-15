//
//  PDFCompressor.swift
//  PDFCompressorKit
//
//  Created by Ghuffran on 15/12/2025.
//

import Foundation
import PDFKit
import CoreGraphics

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A PDF compression utility that works on both iOS (UIKit) and macOS (AppKit)
public final class PDFCompressor: Sendable {
    
    public init() {}
    
    // MARK: - Synchronous Compression
    
    /// Compresses a PDF file from input URL and saves to output URL
    /// - Parameters:
    ///   - inputURL: URL of the source PDF file
    ///   - outputURL: URL where the compressed PDF will be saved
    ///   - level: Compression level to apply
    /// - Throws: `PDFCompressorError` if compression fails
    public func compress(
        inputURL: URL,
        outputURL: URL,
        level: CompressionLevel
    ) throws {
        guard let sourcePDF = PDFDocument(url: inputURL) else {
            throw PDFCompressorError.invalidPDF
        }
        
        let compressedData = try compress(document: sourcePDF, level: level)
        
        // Remove output if already exists
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
        
        try compressedData.write(to: outputURL)
    }
    
    /// Compresses a PDF document and returns the compressed data
    /// - Parameters:
    ///   - document: The PDFDocument to compress
    ///   - level: Compression level to apply
    /// - Returns: Compressed PDF as Data
    /// - Throws: `PDFCompressorError` if compression fails
    public func compress(
        document: PDFDocument,
        level: CompressionLevel
    ) throws -> Data {
        let pageCount = document.pageCount
        
        guard pageCount > 0 else {
            throw PDFCompressorError.invalidPDF
        }
        
        let pdfData = NSMutableData()
        
        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
            throw PDFCompressorError.cannotCreateOutput
        }
        
        var mediaBox = CGRect.zero
        
        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw PDFCompressorError.cannotCreateOutput
        }
        
        for index in 0..<pageCount {
            try autoreleasepool {
                guard let page = document.page(at: index) else {
                    throw PDFCompressorError.compressionFailed
                }
                
                try compressPage(page, to: context, level: level)
            }
        }
        
        context.closePDF()
        
        return pdfData as Data
    }
    
    /// Compresses PDF data and returns compressed data
    /// - Parameters:
    ///   - data: The PDF data to compress
    ///   - level: Compression level to apply
    /// - Returns: Compressed PDF as Data
    /// - Throws: `PDFCompressorError` if compression fails
    public func compress(
        data: Data,
        level: CompressionLevel
    ) throws -> Data {
        guard let document = PDFDocument(data: data) else {
            throw PDFCompressorError.invalidPDF
        }
        return try compress(document: document, level: level)
    }
    
    // MARK: - Async Compression with Progress
    
    /// Compresses a PDF file asynchronously with progress reporting
    /// - Parameters:
    ///   - inputURL: URL of the source PDF file
    ///   - outputURL: URL where the compressed PDF will be saved
    ///   - level: Compression level to apply
    ///   - progress: Progress callback (0.0 to 1.0)
    /// - Throws: `PDFCompressorError` if compression fails
    public func compressAsync(
        inputURL: URL,
        outputURL: URL,
        level: CompressionLevel,
        progress: (@Sendable (Double) -> Void)? = nil
    ) async throws {
        guard let sourcePDF = PDFDocument(url: inputURL) else {
            throw PDFCompressorError.invalidPDF
        }
        
        let compressedData = try await compressAsync(
            document: sourcePDF,
            level: level,
            progress: progress
        )
        
        // Remove output if already exists
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
        
        try compressedData.write(to: outputURL)
    }
    
    /// Compresses a PDF document asynchronously with progress reporting
    /// - Parameters:
    ///   - document: The PDFDocument to compress
    ///   - level: Compression level to apply
    ///   - progress: Progress callback (0.0 to 1.0)
    /// - Returns: Compressed PDF as Data
    /// - Throws: `PDFCompressorError` if compression fails
    public func compressAsync(
        document: PDFDocument,
        level: CompressionLevel,
        progress: (@Sendable (Double) -> Void)? = nil
    ) async throws -> Data {
        let pageCount = document.pageCount
        
        guard pageCount > 0 else {
            throw PDFCompressorError.invalidPDF
        }
        
        let pdfData = NSMutableData()
        
        guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
            throw PDFCompressorError.cannotCreateOutput
        }
        
        var mediaBox = CGRect.zero
        
        guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
            throw PDFCompressorError.cannotCreateOutput
        }
        
        for index in 0..<pageCount {
            try autoreleasepool {
                guard let page = document.page(at: index) else {
                    throw PDFCompressorError.compressionFailed
                }
                
                try compressPage(page, to: context, level: level)
            }
            
            // Report progress
            let currentProgress = Double(index + 1) / Double(pageCount)
            progress?(currentProgress)
            
            // Yield to allow other tasks to run
            await Task.yield()
        }
        
        context.closePDF()
        
        return pdfData as Data
    }
    
    // MARK: - Private Helpers
    
    private func compressPage(
        _ page: PDFPage,
        to context: CGContext,
        level: CompressionLevel
    ) throws {
        let pageRect = page.bounds(for: .mediaBox)
        
        // Create image from PDF page
        guard let image = PlatformImage.from(pdfPage: page, scale: level.scaleFactor) else {
            throw PDFCompressorError.compressionFailed
        }
        
        // Compress image to JPEG
        guard let jpegData = image.jpegData(quality: level.jpegQuality) else {
            throw PDFCompressorError.compressionFailed
        }
        
        // Create image from JPEG data
        #if canImport(UIKit)
        guard let compressedImage = UIImage(data: jpegData),
              let cgImage = compressedImage.cgImage else {
            throw PDFCompressorError.compressionFailed
        }
        #elseif canImport(AppKit)
        guard let compressedImage = NSImage(data: jpegData),
              let cgImage = compressedImage.cgImage(
                forProposedRect: nil,
                context: nil,
                hints: nil
              ) else {
            throw PDFCompressorError.compressionFailed
        }
        #endif
        
        // Draw compressed image to PDF context
        var box = pageRect
        context.beginPage(mediaBox: &box)
        context.draw(cgImage, in: pageRect)
        context.endPage()
    }
}

// MARK: - Convenience Extensions

public extension PDFCompressor {
    
    /// Estimates the compressed file size without actually compressing
    /// - Parameters:
    ///   - inputURL: URL of the source PDF
    ///   - level: Compression level
    /// - Returns: Estimated size in bytes
    func estimateCompressedSize(
        inputURL: URL,
        level: CompressionLevel
    ) throws -> Int {
        guard let sourcePDF = PDFDocument(url: inputURL) else {
            throw PDFCompressorError.invalidPDF
        }
        
        // Estimate based on original size and compression level
        guard let originalData = sourcePDF.dataRepresentation() else {
            throw PDFCompressorError.invalidPDF
        }
        
        let originalSize = originalData.count
        let estimatedRatio: Double
        
        switch level {
        case .low:
            estimatedRatio = 0.7
        case .medium:
            estimatedRatio = 0.4
        case .high:
            estimatedRatio = 0.2
        case .custom(let quality, let scale):
            estimatedRatio = Double(quality * scale) * 0.6
        }
        
        return Int(Double(originalSize) * estimatedRatio)
    }
    
    /// Gets information about a PDF file
    /// - Parameter url: URL of the PDF file
    /// - Returns: Dictionary with PDF information
    func getPDFInfo(url: URL) throws -> [String: Any] {
        guard let document = PDFDocument(url: url) else {
            throw PDFCompressorError.invalidPDF
        }
        
        let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
        let fileSize = attributes[.size] as? Int ?? 0
        
        return [
            "pageCount": document.pageCount,
            "fileSize": fileSize,
            "fileSizeFormatted": ByteCountFormatter.string(
                fromByteCount: Int64(fileSize),
                countStyle: .file
            )
        ]
    }
}
