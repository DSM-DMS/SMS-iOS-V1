import UIKit

protocol dismissBarProtocol {
    func dismissBar(_ value: Bool, _ completion: (()->Void)?)
}

class TabbarViewController: UIViewController, Storyboarded {
    var finish: FinishDelegate!
    var value: Bool = false
    weak var coordinator: TabbarCoordinator?
    var pageCollectionHeightConstraint: NSLayoutConstraint!
    
    lazy var scheduleCoordinator = ScheduleCoordinator(nav: UINavigationController(), finish: finish)
    lazy var outGoingCoordinator = OutGoingCoordinator(nav: UINavigationController(), finish: finish)
    lazy var noticeCoordinator = NoticeCoordinator(nav: UINavigationController(), finish: finish)
    lazy var myPageCoordinator = MyPageCoordinator(nav: UINavigationController(), finish: finish)
    
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
    
    var stackView = UIStackView()
    
    var tabbar = TabbarView()
    
    var viewOnTabbar = UIView()
    
    var tabbarHeightConstraint: NSLayoutConstraint!
    
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupPageCollectionView()
        let vc = MypageViewController()
        vc.delegate = self
        outGoingCoordinator.delegate = self
        noticeCoordinator.delegate = self
        myPageCoordinator.delegate = self
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        self.automaticallyAdjustsScrollViewInsets = false
    }
}

extension TabbarViewController {
    func setupStackView() {
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(tabbar)
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.alignment = .fill
        setupCustomTabBar()
        
        stackView.addShadow(maskValue: true,
                            offset: CGSize(width: 0, height: -1),
                            color: .gray,
                            shadowRadius: 10,
                            opacity: 0.25,
                            cornerRadius: 10,
                            corner: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    func setupCustomTabBar(){
        
        self.view.addSubviews([pageCollectionView])
        tabbar.indicatorViewWidthConstraint.constant = self.view.frame.width / 8
        tabbar.indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        self.tabbarHeightConstraint = tabbar.heightAnchor.constraint(equalToConstant: view.frame.height / 8)
        self.tabbarHeightConstraint.isActive = true
        tabbar.indicatorViewLeadingConstraint.constant = self.view.frame.width / 16
        tabbar.delegate = self
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupPageCollectionView(){
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageCollectionHeightConstraint = pageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height - (view.frame.height / 10) - 14)
        pageCollectionHeightConstraint.isActive = true
    }
}

extension TabbarViewController: TabbarViewDelegate, dismissBarProtocol {
    func tabbarView(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func dismissBar(_ value: Bool, _ completion: (() -> Void)?) {
        pageCollectionView.isScrollEnabled = !value
        pageCollectionView.isPagingEnabled = !value
        stackView.isHidden = value
        pageCollectionHeightConstraint.constant = value ? view.frame.height : view.frame.height - (view.frame.height / 10) - 14
        self.value = value
        
        UIView.performWithoutAnimation {
            self.pageCollectionView.reloadItems(at: self.pageCollectionView.indexPathsForVisibleItems)
        }
        pageCollectionView.layoutIfNeeded()
        
        if let completion = completion {
            completion()
        }
    }
}

extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.NibName, for: indexPath) as! PageCell
        let vcView = vcArr[indexPath.item].nav.view
        vcView?.frame = cell.contentView.bounds
        cell.contentView.addSubview(vcView ?? UIView())
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
        let height:CGFloat = self.value ? UIScreen.main.bounds.height : view.frame.height - (view.frame.height / 10 ) - 14
        return CGSize(width: pageCollectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension TabbarViewController: Aaaa {
    func logOutAlertIsHidden(_ value: Bool) {
        print("123123123123")
        tabbar.alpha = value ? 1 : 0.3
        tabbar.backgroundColor = value ? .white : .black
    }
}
