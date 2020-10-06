import UIKit

class CustomCell: UICollectionViewCell {
    
    static let xibName = "CustomCell"
    
    @IBOutlet var imageView: UIImageView!
  
    override var isSelected: Bool {
        didSet{
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            self.imageView.tintColor = isSelected ? .customPurple : .customBlack
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .customBlack
    }
}
