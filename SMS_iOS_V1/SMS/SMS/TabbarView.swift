import UIKit

protocol TabbarViewDelegate: class {
    func tabbarView(scrollTo index: Int)
}

class TabbarView: UIView {
    
    let imageNames = ["calendar","outgoing","notice","mypage"]
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
    weak var delegate: TabbarViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        setupCustomTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: CustomCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: CustomCell.reusableIdentifier)
        collectionView.layer.masksToBounds = false
        collectionView.layer.cornerRadius = 20
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.addShadow(offset: CGSize(width: 0, height: -2.5),
                                             color: .gray,
                                             radius: CGFloat(2),
                                             opacity: 0.5)
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(displayP3Red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
        return view
    }()
    
    func setupCollectioView(){
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func setupCustomTabBar(){
        setupCollectioView()
        
        self.addSubviews([customTabBarCollectionView, indicatorView])
        
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 62).isActive = true

        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 8)
        indicatorViewWidthConstraint.isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}

//MARK:- UICollectionViewDelegate, DataSource
extension TabbarView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reusableIdentifier, for: indexPath) as! CustomCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 , height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.item) * customTabBarCollectionView.frame.width / 4 + 25
        indicatorViewLeadingConstraint.constant = x
        delegate?.tabbarView(scrollTo: indexPath.row)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else {return}
        cell.imageView.image = cell.imageView.image?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = .init(red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else {return}
        cell.imageView.image = cell.imageView.image?.withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = .init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
    }
}

extension TabbarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float)
    {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

