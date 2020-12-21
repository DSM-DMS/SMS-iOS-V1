import UIKit
import os

protocol dismissBarProtocol {
    func dismissBar(_ value: Bool)
}

class TabbarViewController: UIViewController, Storyboarded {
    weak var coordinator: TabbarCoordinator?
    var pageCollectionHeightConstraint: NSLayoutConstraint!
    
    let scheduleCoordinator = ScheduleCoordinator(nav: UINavigationController())
    let outGoingCoordinator = OutGoingCoordinator(nav: UINavigationController())
    let noticeCoordinator = NoticeCoordinator(nav: UINavigationController())
    let myPageCoordinator = MyPageCoordinator(nav: UINavigationController())
    
    lazy var vcArr: [Coordinator] = [scheduleCoordinator, outGoingCoordinator, noticeCoordinator, myPageCoordinator]
    
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
    
    var tabbarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupPageCollectionView()
        outGoingCoordinator.delegate = self
        noticeCoordinator.delegate = self
        myPageCoordinator.delegate = self
    }
}

extension TabbarViewController {
    func setupCustomTabBar(){
        self.view.addSubviews([tabbar,pageCollectionView])
        tabbar.indicatorViewWidthConstraint.constant = self.view.frame.width / 8
        tabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tabbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tabbar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 800).isActive = true
        self.tabbarHeightConstraint = tabbar.heightAnchor.constraint(equalToConstant: view.frame.height / 10)
        self.tabbarHeightConstraint.isActive = true
        tabbar.indicatorViewLeadingConstraint.constant = self.view.frame.width / 16
        tabbar.delegate = self
    }
    
    func setupPageCollectionView(){
        
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageCollectionHeightConstraint = pageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height - (view.frame.height / 10 + 2))
        pageCollectionHeightConstraint.isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  view.frame.height - tabbar.frame.height)
    }
}

extension TabbarViewController: TabbarViewDelegate, dismissBarProtocol {
    func tabbarView(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func dismissBar(_ value: Bool) {
        pageCollectionView.isScrollEnabled = !value
        pageCollectionView.isPagingEnabled = !value
        tabbarHeightConstraint.constant = !value ? view.frame.height / 10 : 0
        pageCollectionHeightConstraint.constant = !value ? view.frame.height - (view.frame.height / 10 + 2) : view.frame.height
        !value ? setupPageCollectionView() : print(1)
    }
}

extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.xibName, for: indexPath) as! PageCell
        let vcView = vcArr[indexPath.row].nav.view!
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
