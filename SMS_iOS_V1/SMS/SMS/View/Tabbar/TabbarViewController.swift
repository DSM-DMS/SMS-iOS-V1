import UIKit

class TabbarViewController: UIViewController, Storyboarded {
    weak var coordinator: TabbarCoordinator?
    lazy var vcArr:[Coordinator] = [scheduleCoordinator, outGoingCoordinator, noticeCoordinator, myPageCoordinator]
    
    let scheduleCoordinator = ScheduleCoordinator(nav: UINavigationController())
    let outGoingCoordinator = OutGoingCoordinator(nav: UINavigationController())
    let noticeCoordinator = NoticeCoordinator(nav: UINavigationController())
    let myPageCoordinator = MyPageCoordinator(nav: UINavigationController())
    
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
        collectionView.register(PageCell.self)
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
        tabbar.indicatorViewWidthConstraint.constant = self.view.frame.width / 8
        tabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tabbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tabbar.heightAnchor.constraint(equalToConstant: self.view.frame.height / 10).isActive = true
        tabbar.indicatorViewLeadingConstraint.constant = self.view.frame.width / 16
        tabbar.delegate = self
    }
    
    func tabbarView(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView(){
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: tabbar.topAnchor, constant: -5).isActive = true
    }
}

extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource, TabbarViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.xibName, for: indexPath) as! PageCell
        let vcView = vcArr[indexPath.row].nav.view!
        vcArr[indexPath.row].nav.setNavigationBarHidden(true, animated: false)
        vcView.frame = cell.contentView.bounds
        cell.contentView.addSubview(vcView)
        vcArr[indexPath.row].start()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tabbar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4 + self.view.frame.width / 16
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        tabbar.setSelectedItem(index: itemAt)
        tabbar.customTabBarCollectionView.selectItem(at: IndexPath(item: itemAt, section: 0), animated: true, scrollPosition: [])
    }
}

extension TabbarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
