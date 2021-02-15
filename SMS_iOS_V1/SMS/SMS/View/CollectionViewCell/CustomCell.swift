import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var tabbar:Tabbar? {
        didSet {
            guard let tabbar: Tabbar = tabbar else { return }
            self.imageView.image = UIImage(named: tabbar.imageName)?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = tabbar.isSelected ? .customPurple : .customBlack
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .customBlack
    }
}
