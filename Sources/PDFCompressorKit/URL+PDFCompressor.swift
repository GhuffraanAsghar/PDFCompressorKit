//
//  URL+PDFCompressor.swift
//  PDFCompressorKit
//
//  Created by Ghuffran on 15/12/2025.
//

import Foundation

public extension URL {
    
    /// Compresses the PDF file at this URL.
    /// This provides a simplified, one-line API for PDF compression.
    ///
    /// - Parameters:
    ///   - outputURL: The destination URL for the compressed PDF. If nil, overwrites the current file.
    ///   - level: The compression level to use. Defaults to `.optimal`.
    /// - Throws: `PDFCompressorError` if the file is not a valid PDF or compression fails.
    func compressPDF(to outputURL: URL? = nil, level: CompressionLevel = .optimal) throws {
        let compressor = PDFCompressor()
        let destination = outputURL ?? self
        
        // If overwriting the same file, write to a temporary file first to avoid corruption
        if destination == self {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
            try compressor.compress(inputURL: self, outputURL: tempURL, level: level)
            _ = try FileManager.default.replaceItemAt(self, withItemAt: tempURL)
        } else {
            try compressor.compress(inputURL: self, outputURL: destination, level: level)
        }
    }
    
    /// Compresses the PDF file asynchronously.
    /// This provides a simplified, one-line API for PDF compression.
    ///
    /// - Parameters:
    ///   - outputURL: The destination URL for the compressed PDF. If nil, overwrites the current file.
    ///   - level: The compression level to use. Defaults to `.optimal`.
    ///   - progress: Optional callback for tracking compression progress (0.0 to 1.0)
    /// - Throws: `PDFCompressorError` if the file is not a valid PDF or compression fails.
    func compressPDFAsync(
        to outputURL: URL? = nil,
        level: CompressionLevel = .optimal,
        progress: ((Double) -> Void)? = nil
    ) async throws {
        let compressor = PDFCompressor()
        let destination = outputURL ?? self
        
        if destination == self {
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
            try await compressor.compressAsync(inputURL: self, outputURL: tempURL, level: level, progress: progress)
            _ = try FileManager.default.replaceItemAt(self, withItemAt: tempURL)
        } else {
            try await compressor.compressAsync(inputURL: self, outputURL: destination, level: level, progress: progress)
        }
    }
}
