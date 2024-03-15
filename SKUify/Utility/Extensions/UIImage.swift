//
//  UIImage.swift
//  SKUify
//
//  Created by George Churikov on 25.01.2024.
//

import Foundation
import UIKit
import CoreImage

extension UIImage {
    func round(_ radius: CGFloat) -> UIImage {
           let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
           let renderer = UIGraphicsImageRenderer(size: rect.size)
           let result = renderer.image { c in
               let rounded = UIBezierPath(roundedRect: rect, cornerRadius: radius)
               rounded.addClip()
               if let cgImage = self.cgImage {
                   UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation).draw(in: rect)
               }
           }
           return result
       }
    
}
