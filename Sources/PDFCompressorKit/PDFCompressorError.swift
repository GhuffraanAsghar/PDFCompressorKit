//
//  PDFCompressorError.swift
//  PDFCompressorKit
//
//  Created by Ghuffran on 15/12/2025.
//

import Foundation

/// Errors that can occur during PDF compression
public enum PDFCompressorError: Error, LocalizedError, Sendable {
    /// The input PDF is invalid or cannot be read
    case invalidPDF
    /// Cannot create the output file or data consumer
    case cannotCreateOutput
    /// Compression failed during processing
    case compressionFailed
    /// The input file was not found
    case fileNotFound
    
    public var errorDescription: String? {
        switch self {
        case .invalidPDF:
            return "The PDF file is invalid or cannot be read."
        case .cannotCreateOutput:
            return "Cannot create the output file."
        case .compressionFailed:
            return "PDF compression failed during processing."
        case .fileNotFound:
            return "The specified file was not found."
        }
    }
}
