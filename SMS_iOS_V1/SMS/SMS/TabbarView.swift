//
//  CustomMenuBar.swift
//  CustomTabBar
//
//  Created by 이동건 on 2018. 4. 20..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit

protocol CustomMenuBarDelegate: class {
    func customMenuBar(scrollTo index: Int)
}

class CustomMenuBar: UIView {
    
    let storyboardNames: [Int:String] = [0:"Login",1:"OutGoing",2:"Notice",3:"MyPage"]
    let viewcontrollerNames: [Int:String] = [0:"LoginViewController",1:"OutGoingViewController",2:"NoticeViewController",3:"MypageViewController"]
    
    weak var delegate: CustomMenuBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomTabBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customTabBarCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(red: 83/255, green: 35/255, blue: 178/255, alpha: 1)
        return view
    }()
    //MARK: Properties
    var indicatorViewLeadingConstraint:NSLayoutConstraint!
    var indicatorViewWidthConstraint: NSLayoutConstraint!
    //MARK: Setup Views
    func setupCollectioView(){
        customTabBarCollectionView.delegate = self
        customTabBarCollectionView.dataSource = self
        customTabBarCollectionView.showsHorizontalScrollIndicator = false
        customTabBarCollectionView.register(UINib(nibName: CustomCell.reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: CustomCell.reusableIdentifier)
        customTabBarCollectionView.isScrollEnabled = false
        
        let indexPath = IndexPath(item: 0, section: 0)
        customTabBarCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func setupCustomTabBar(){
        setupCollectioView()
        self.addSubview(customTabBarCollectionView)
        customTabBarCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customTabBarCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customTabBarCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customTabBarCollectionView.heightAnchor.constraint(equalToConstant: 62).isActive = true
        customTabBarCollectionView.layer.masksToBounds = false
        customTabBarCollectionView.layer.cornerRadius = 20
        customTabBarCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        customTabBarCollectionView.addShadow(offset: CGSize(width: 0, height: -2.5),
                                     color: .gray,
                                     radius: CGFloat(2),
                                     opacity: 0.5)
        self.addSubview(indicatorView)
        indicatorViewWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: self.frame.width / 4 + 30)
        indicatorViewWidthConstraint.isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorViewLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        indicatorViewLeadingConstraint.isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

//MARK:- UICollectionViewDelegate, DataSource
extension CustomMenuBar: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.reusableIdentifier, for: indexPath) as! CustomCell
//        cell.imageView.image = UIImage(named: imageNames[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 4 , height: 62)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let x = CGFloat(indexPath.item) * customTabBarCollectionView.frame.width / 4 
        indicatorViewLeadingConstraint.constant = x
        delegate?.customMenuBar(scrollTo: indexPath.row)
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
//MARK:- UICollectionViewDelegateFlowLayout
extension CustomMenuBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CustomMenuBar {
    func changeVC<T>(_ storyBoardIdentifier: String ,_ identifier: String) -> T? {
        let storyboard = UIStoryboard.init(name: storyBoardIdentifier, bundle: .main)
        guard let vc = storyboard.instantiateViewController(identifier: identifier) as? T else { return nil}
        return vc
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


//let vcNames = ["LoginViewController", "OutGoingViewController", "NoticeViewController", "MypageViewController"]
