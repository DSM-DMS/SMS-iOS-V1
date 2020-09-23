import UIKit

protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}

class TabbarView: UIView {
    weak var delegate: CustomMenuBarDelegate?
    
    var customTabbarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tabbarViewSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionViewSetting() {
        tabbarViewSetting()
        customTabbarCollectionView.delegate = self
        customTabbarCollectionView.dataSource = self
        customTabbarCollectionView.register(TabbarCell.self, forCellWithReuseIdentifier: "tabbar")
        customTabbarCollectionView.isScrollEnabled = false
        customTabbarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
    }
    
    func tabbarViewSetting() {
        collectionViewSetting()
        customTabbarCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        customTabbarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabbarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabbarCollectionView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.addSubview(customTabbarCollectionView)
        indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 4).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    }
}

extension TabbarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = customTabbarCollectionView.dequeueReusableCell(withReuseIdentifier: "tabbar", for: indexPath) as! TabbarCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.customMenuBar(scrollTo: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TabbarCell else { return }
        let newImage = cell.imageVIew.image?.withRenderingMode(.alwaysTemplate)
        cell.imageVIew.image = newImage
        cell.imageVIew.tintColor = .init(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 , height: 64)
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
