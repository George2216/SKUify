//
//  UIImage.swift
//  SKUify
//
//  Created by George Churikov on 25.01.2024.
//

import Foundation
import UIKit
import CoreImage
import SDWebImage
import AssetsLibrary

extension UIImage {
    func convertToJPEG(quality: CGFloat = 0.8) -> Data? {
        if let ciImage = CIImage(image: self) {
            
            // Создаем CIContext
            let context = CIContext(options: nil)
            
            // Создаем CGImage из CIImage с помощью CIContext
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                // Создаем UIImage из CGImage
                let finalImage = UIImage(cgImage: cgImage)
                
                // Используем finalImage по вашему усмотрению
                return finalImage.jpegData(compressionQuality: quality)
            }
        }
        return nil
    }
            /**
            - Convert heic image to jpeg format
        */
    public func getJpegData(imageData: Data, referenceUrl: URL) -> Data? {
        var newImageSize: Data?

        if FileManager.default.fileExists(atPath: referenceUrl.path) {
            let image = UIImage(data: imageData)
            newImageSize = image?.jpegData(compressionQuality: 1.0)
        }

        return newImageSize
    }
}
