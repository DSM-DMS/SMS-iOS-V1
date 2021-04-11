import UIKit

class DevCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var partLbl: UILabel!
    
    func setting(_ people: People) {
        imageView.image = UIImage(named: people.image)
        imageView.layer.cornerRadius = imageView.frame.height / 1.95
        nameLbl.text = people.name
        partLbl.text = people.part
    }
}
