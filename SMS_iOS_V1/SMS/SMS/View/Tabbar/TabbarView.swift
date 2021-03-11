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
    var oldSelectedRow: Int = 0
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    var height: CGFloat = 0
    
    var imageNames:[Tabbar] = [
        Tabbar(imageName: "calendar", isSelected: true),
        Tabbar(imageName: "outgoing"),
        Tabbar(imageName: "notice"),
        Tabbar(imageName: "mypage")
    ]
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customPurple
        return view
    }()
    
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
        collectionView.register(CustomCell.self)
        collectionView.addShadow(maskValue: true,
                                 offset: CGSize(width: 0, height: -0.5),
                                 color: .gray,
                                 shadowRadius: 2,
                                 opacity: 0.5,
                                 cornerRadius: 20,
                                 corner: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false
        setupCustomTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.height <= 0 {
            self.height = self.frame.height - 2
            setupCustomCollectionView()
        }
    }
    
    func setupCustomCollectionView() {
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        let constant: CGFloat = UIScreen.main.bounds.height > 800 ? 30 : 20
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant).isActive = true
    }
    
    func setupCustomTabBar(){
        self.addSubviews([customTabBarCollectionView, indicatorView])
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 8)
        indicatorViewWidthConstraint.isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorView.topAnchor.constraint(equalTo: self.customTabBarCollectionView.bottomAnchor).isActive = true
    }
    
    func setSelectedItem(index: Int) -> Void {
        self.imageNames[oldSelectedRow].isSelected = false
        self.imageNames[index].isSelected = true
        self.oldSelectedRow = index
        
        customTabBarCollectionView.reloadData()
    }
}

extension TabbarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.NibName, for: indexPath) as! CustomCell
        cell.tabbar = imageNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4, height: self.frame.height - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row: Int = indexPath.row
        self.setSelectedItem(index: row)
        delegate?.tabbarView(scrollTo: indexPath.row)
    }
}

extension TabbarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
