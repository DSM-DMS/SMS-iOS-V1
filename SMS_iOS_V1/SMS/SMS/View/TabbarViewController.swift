import UIKit

class TabbarViewController: UIViewController, TabbarViewDelegate{
    
    let loginVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(identifier: "LoginViewController")
    let outGoingVC = UIStoryboard(name: "OutGoing", bundle: .main).instantiateViewController(identifier: "OutGoingViewController")
    let noticeVC = UIStoryboard(name: "Notice", bundle: .main).instantiateViewController(identifier: "NoticeViewController")
    let mypageVC = UIStoryboard(name: "MyPage", bundle: .main).instantiateViewController(identifier: "MypageViewController")

    lazy var vcArr = [loginVC, outGoingVC, noticeVC, mypageVC]
    
    lazy var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: PageCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reusableIdentifier)
        return collectionView
    }()
    
    var tabbar = TabbarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupPageCollectionView()
    }
    
    func setupCustomTabBar(){
        self.view.addSubviews([tabbar,pageCollectionView])
        tabbar.delegate = self
        tabbar.indicatorViewWidthConstraint.constant = self.view.frame.width / 8 
        tabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tabbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tabbar.heightAnchor.constraint(equalToConstant: 62).isActive = true
        tabbar.indicatorViewLeadingConstraint.constant = 25
    }
    
    func tabbarView(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView(){
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.tabbar.topAnchor).isActive = true
    }
}
//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reusableIdentifier, for: indexPath) as! PageCell
        let vcView = vcArr[indexPath.row].view!
        vcView.frame = cell.contentView.bounds
        cell.contentView.addSubview(vcView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabbar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4 + 25
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        tabbar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}
//MARK:- UICollectionViewDelegateFlowLayout
extension TabbarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension TabbarViewController {
    func changeVC<T>(_ storyBoardIdentifier: StoryboardNames ,_ identifier: ViewControllerNames) -> T? {
        let storyboard = UIStoryboard.init(name: storyBoardIdentifier.rawValue, bundle: .main)
        guard let vc = storyboard.instantiateViewController(identifier: identifier.rawValue) as? T else { return nil}
        return vc
    }
    
    enum StoryboardNames: String {
        case outgoing = "OutGoing"
        case notice = "Notice"
        case mypage = "MyPage"
    //    case schedule = "Schedule"
        case login = "Login"
    }

    enum ViewControllerNames: String {
        case outgoing = "OutGoingViewController"
        case notice = "NoticeViewController"
        case mypage = "MypageViewController"
        case login = "LoginViewController"
    }
}


