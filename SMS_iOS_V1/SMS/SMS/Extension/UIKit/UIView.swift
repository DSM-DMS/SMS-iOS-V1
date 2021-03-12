import UIKit

extension UIView {
    static var NibName: String {
        return String(describing: self)
    }
    
    func addSubviews(_ views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func addShadow(maskValue: Bool, offset: CGSize, color: UIColor, shadowRadius: CGFloat, opacity: Float, cornerRadius: CGFloat, corner: CACornerMask? = nil) {
        layer.masksToBounds = maskValue
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corner ?? [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMinYCorner]
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func backgroundColorForDarkMode(_ color: UIColor? = nil) -> UIColor {
        if self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
            return color ?? .black
        } else {
            return color ?? .white
        }
    }
}
