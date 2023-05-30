//
//  UIImageView+LoadFrom.swift
//

import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }
        
        DispatchQueue.main.async {
            if let imageData  = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self.image = loadedImage
                }
            }
        }
    }
}
