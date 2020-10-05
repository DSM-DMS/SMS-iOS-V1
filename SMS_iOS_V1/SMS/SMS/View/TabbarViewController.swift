//
//  MainVC.swift
//  CustomTabBar
//
//  Created by 이동건 on 2018. 4. 18..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit

class TabbarViewController: UIViewController, TabbarViewDelegate{
    
    let loginVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(identifier: "LoginViewController")
    let outGoingVC = UIStoryboard(name: "OutGoing", bundle: .main).instantiateViewController(identifier: "OutGoingViewController")
    let noticeVC = UIStoryboard(name: "Notice", bundle: .main).instantiateViewController(identifier: "NoticeViewController")
    let mypageVC = UIStoryboard(name: "MyPage", bundle: .main).instantiateViewController(identifier: "MypageViewController")

    lazy var vcArr = [loginVC, outGoingVC, noticeVC, mypageVC]
    
    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var tabbar = TabbarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupPageCollectionView()
    }
    //MARK: Setup view
    func setupCustomTabBar(){
        self.view.addSubview(tabbar)
        tabbar.delegate = self
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        tabbar.indicatorViewWidthConstraint.constant = self.view.frame.width / 8 
        tabbar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tabbar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tabbar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tabbar.heightAnchor.constraint(equalToConstant: 62).isActive = true
        tabbar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabbar.clipsToBounds = false
        tabbar.indicatorViewLeadingConstraint.constant = 25
    }
    
    func tabbarView(scrollTo index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupPageCollectionView(){
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.showsHorizontalScrollIndicator = false
        pageCollectionView.isPagingEnabled = true
        pageCollectionView.register(UINib(nibName: PageCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reusableIdentifier)
        self.view.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.tabbar.topAnchor).isActive = true
        for vc in vcArr {
            self.addChild(vc)
            vc.didMove(toParent: self)
            self.view.addSubview(vc.view)
            vc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 100)
        }
        pageCollectionView.reloadData()
    }
}
//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reusableIdentifier, for: indexPath) as! PageCell
        cell.contentView.addSubview(vcArr[indexPath.row].view)
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


