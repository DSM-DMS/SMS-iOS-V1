import UIKit

protocol TabbarViewDelegate {
    func tabbarView(scrollTo index: Int)
}

struct Tabbar {
    let imageName:String
    var isSelected:Bool
    
    init(imageName:String, isSelected:Bool = false) {
        self.imageName = imageName
        self.isSelected = isSelected
    }
}

class TabbarView: UIView {
    
    var delegate: TabbarViewDelegate!
    var oldSelectedRow:Int = 0

    var imageNames:[Tabbar] = [
        Tabbar(imageName: "calendar", isSelected: true),
        Tabbar(imageName: "outgoing"),
        Tabbar(imageName: "notice"),
        Tabbar(imageName: "mypage")
    ]
    
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: CustomCell.xibName, bundle: nil), forCellWithReuseIdentifier: CustomCell.xibName)
        collectionView.layer.masksToBounds = false
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        collectionView.addShadow(offset: CGSize(width: 0, height: -2.5),
                                 color: .gray,
                                 shadowRadius: 2,
                                 opacity: 0.5,
                                 cornerRadius: 20)
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customPurple
        return view
    }()
    
    func setupCustomTabBar(){
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
    
    func setSelectedItem(index: Int) -> Void {
        self.imageNames[oldSelectedRow].isSelected = false
        self.imageNames[index].isSelected = true
        self.oldSelectedRow = index
        
        customTabBarCollectionView.reloadData()
    }
    
//    func setSelectedItem(index: Int) -> Void {
//        
//    }
}

extension TabbarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.xibName, for: indexPath) as! CustomCell
        cell.tabbar = imageNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 , height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row: Int = indexPath.row
        self.setSelectedItem(index: row)
        delegate?.tabbarView(scrollTo: indexPath.row)
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
