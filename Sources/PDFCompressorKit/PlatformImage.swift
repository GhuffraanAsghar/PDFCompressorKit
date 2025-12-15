//
//  PlatformImage.swift
//  PDFCompressorKit
//
//  Created by Ghuffran on 15/12/2025.
//

import Foundation
import PDFKit
import CoreGraphics

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

// MARK: - Cross-Platform Image Extensions

public extension PlatformImage {
    
    /// Creates an image from a PDF page at the specified scale
    static func from(pdfPage: PDFPage, scale: CGFloat) -> PlatformImage? {
        let pageRect = pdfPage.bounds(for: .mediaBox)
        let scaledSize = CGSize(
            width: pageRect.width * scale,
            height: pageRect.height * scale
        )
        
        #if canImport(UIKit)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let image = renderer.image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: scaledSize))
            
            context.cgContext.translateBy(x: 0, y: scaledSize.height)
            context.cgContext.scaleBy(x: scale, y: -scale)
            
            if let pageRef = pdfPage.pageRef {
                context.cgContext.drawPDFPage(pageRef)
            }
        }
        return image
        
        #elseif canImport(AppKit)
        let image = NSImage(size: scaledSize)
        image.lockFocus()
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return nil
        }
        
        NSColor.white.setFill()
        context.fill(CGRect(origin: .zero, size: scaledSize))
        
        context.scaleBy(x: scale, y: scale)
        
        if let pageRef = pdfPage.pageRef {
            context.drawPDFPage(pageRef)
        }
        
        image.unlockFocus()
        return image
        #endif
    }
    
    /// Converts the image to JPEG data with the specified quality (0.0 - 1.0)
    func jpegData(quality: CGFloat) -> Data? {
        #if canImport(UIKit)
        return self.jpegData(compressionQuality: quality)
        
        #elseif canImport(AppKit)
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        return bitmap.representation(
            using: .jpeg,
            properties: [.compressionFactor: quality]
        )
        #endif
    }
    
    /// Returns the size of the image
    var imageSize: CGSize {
        #if canImport(UIKit)
        return self.size
        #elseif canImport(AppKit)
        return self.size
        #endif
    }
}
