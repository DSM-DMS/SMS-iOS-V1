import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) -> Void {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIColor {
    static var customPurple: UIColor {
        return UIColor(displayP3Red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
    }
    
    static var customBlack: UIColor {
        return UIColor(displayP3Red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
    }
}

    
//    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
//        layer.masksToBounds = false
//        layer.shadowOffset = offset
//        layer.shadowColor = color.cgColor
//        layer.shadowRadius = radius
//        layer.shadowOpacity = opacity
//        
//        let backgroundCGColor = backgroundColor?.cgColor
//        backgroundColor = nil
//        layer.backgroundColor =  backgroundCGColor
//    }
//}

