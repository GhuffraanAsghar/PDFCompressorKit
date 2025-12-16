//
//  CompressionLevel.swift
//  PDFCompressorKit
//
//  Created by Ghuffran on 15/12/2025.
//

import Foundation
import CoreGraphics

public enum CompressionLevel {
    /// Low compression - high quality, larger file size
    case low
    /// Medium compression - balanced quality and size
    case medium
    /// High compression - lower quality, smaller file size
    case high
    /// Custom compression with specific quality and scale values
    case custom(quality: CGFloat, scale: CGFloat)
    
    /// JPEG quality (0.0 - 1.0, higher = better quality)
    public var jpegQuality: CGFloat {
        switch self {
        case .low:    return 0.9
        case .medium: return 0.6
        case .high:   return 0.3
        case .custom(let quality, _): return max(0.1, min(1.0, quality))
        }
    }
    
    /// Scale factor for image resolution (0.0 - 1.0, higher = higher resolution)
    public var scaleFactor: CGFloat {
        switch self {
        case .low:    return 1.0   // Full resolution
        case .medium: return 0.75  // 75% resolution
        case .high:   return 0.5   // 50% resolution
        case .custom(_, let scale): return max(0.25, min(1.0, scale))
        }
    }
}
