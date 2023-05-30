//
//  UITextField+LeftIcon.swift
//  

import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage?) {
        let iconView = UIImageView(frame: CGRect(x: 15, y: 4, width: 50, height: 20))
        iconView.image = image
        iconView.contentMode = .scaleAspectFit
        
        //let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        //iconContainerView.addSubview(iconView)
        
        leftView = iconView
        leftViewMode = .always
    }
    
    //usage .roundCorners(corners: [.topLeft, .topRight])
//    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = bounds
//        maskLayer.path = UIBezierPath(
//            roundedRect: bounds,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        ).cgPath
//        
//        layer.mask = maskLayer
//    }
}


