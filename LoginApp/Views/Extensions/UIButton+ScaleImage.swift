//
//  UIButton+ResizeImage.swift
//

import UIKit

extension UIButton {
    func scaleImage(width: CGFloat, height: CGFloat) {
        let size = (self.imageView?.image?.size)!
        let inset = CGSize(width: size.width * width, height: size.height * height)
        self.imageEdgeInsets = UIEdgeInsets(top: inset.height , left: inset.width, bottom: inset.height, right: inset.width)
    }
}
