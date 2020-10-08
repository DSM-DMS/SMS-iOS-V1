import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor, shadowRadius: CGFloat, opacity: Float, cornerRadius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.cornerRadius = cornerRadius
    }
}
