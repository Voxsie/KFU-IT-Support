//
//  UIImage+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 02.04.2024.
//

import Foundation
import UIKit

func svgImage(
    image: UIImage,
    width: Int,
    height: Int
) -> UIImage {

    let size = image.size
    let uSize = CGSize(width: width, height: height)
    let uWidth = uSize.width / image.size.width
    let uHeight = uSize.height / image.size.height

    var newSize: CGSize
    if uWidth > uHeight {
        newSize = CGSize(width: size.width * uHeight, height: size.height * uHeight)
    } else {
        newSize = CGSize(width: size.width * uWidth, height: size.height * uWidth)
    }

    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)

    image.draw(in: rect)

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage ?? image
}
