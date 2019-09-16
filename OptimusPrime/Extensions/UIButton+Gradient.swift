//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import Foundation
import UIKit

extension UIButton {
    func addGradient() {
        if let gradientImage = gradientImage(direction: .north, colors: [.white, .lightGray, .darkGray, .lightGray]) {
            setBackgroundImage(gradientImage, for: .normal)
        }
    }
}

extension UIView {
    func gradientImage(direction: GradientDirection, colors: [UIColor]) -> UIImage? {
        return image(from: gradientLayer(frame: bounds, direction: direction, colors: colors.map { $0.cgColor }))
    }

    func addGradient(direction: GradientDirection, colors: [UIColor]) {
        removePreviousGradient()
        layer.addSublayer(gradientLayer(frame: bounds, direction: direction, colors: colors.map { $0.cgColor }))
        for subview in subviews {
            bringSubviewToFront(subview)
        }
    }

    private func gradientLayer(frame: CGRect, direction: GradientDirection, colors: [CGColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.opacity = 1.0
        gradientLayer.startPoint = direction.initialPoint()
        gradientLayer.endPoint = direction.endPoint()
        return gradientLayer
    }

    private func removePreviousGradient() {
        guard let sublayers = layer.sublayers else { return }
        for gradient in sublayers.filter({ (layer) -> Bool in layer is CAGradientLayer }) {
            gradient.removeFromSuperlayer()
        }
    }

    private func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public enum GradientDirection: Int {
    case north = 0, northEast, east, southEast, south, southWest, west, northWest

    private var opposed: GradientDirection {
        return GradientDirection(rawValue: (rawValue + 4) % 8)!
    }

    func initialPoint() -> CGPoint {
        return opposed.endPoint()
    }

    func endPoint() -> CGPoint {
        switch self {
        case .north:
            return CGPoint(x: 0.5, y: 0.0)
        case .northEast:
            return CGPoint(x: 1.0, y: 0.0)
        case .east:
            return CGPoint(x: 1.0, y: 0.5)
        case .southEast:
            return CGPoint(x: 1.0, y: 1.0)
        case .south:
            return CGPoint(x: 0.5, y: 1.0)
        case .southWest:
            return CGPoint(x: 0.0, y: 1.0)
        case .west:
            return CGPoint(x: 0.0, y: 0.5)
        case .northWest:
            return CGPoint(x: 0.0, y: 0.0)
        }
    }
}
