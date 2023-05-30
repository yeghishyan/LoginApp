//
//  CustomSlider.swift
//

import UIKit

class VideoPlayerSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 6
        return rect
    }
}
