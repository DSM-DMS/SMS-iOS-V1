//
//  PageCell.swift
//  SMS
//
//  Created by 이현욱 on 2020/09/25.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

protocol PageCellProtocol: class {
    func willAdd(_ childViewController: UIViewController, at index: Int)
}

class PageCell: UICollectionViewCell {
    
    weak var delegate: PageCellProtocol!
    
    @IBOutlet var vcView: UIView!

    let loginVC = UIStoryboard(name: "Login", bundle: .main).instantiateViewController(identifier: "LoginViewController")
    let outGoing = UIStoryboard(name: "OutGoing", bundle: .main).instantiateViewController(identifier: "OutGoingViewController")
    let notice = UIStoryboard(name: "Notice", bundle: .main).instantiateViewController(identifier: "NoticeViewController")
    let mypage = UIStoryboard(name: "MyPage", bundle: .main).instantiateViewController(identifier: "MypageViewController")
    
    lazy var vcArr = [loginVC, outGoing, notice, mypage]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addChild(at index: Int, to viewController: UIViewController, displayIn contentView: UIView) {
        let childVC: V
        if let vc = viewControllers[index] {
            print("Using cached view controller")
            childVC = vc
        } else {
            print("Creating new view controller")
            childVC = V()
            viewControllers[index] = childVC
        }

        delegate?.willAdd(childVC, at: index)

        viewController.addChild(childVC)
        childVC.view.frame = contentView.bounds
        contentView.addSubview(childVC.view)
        childVC.didMove(toParent: viewController)
    }

    func remove(at index: Int) {
        print("Remove at \(index)")
        guard let vc = viewControllers[index] else { return }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }

    func cleanCachedViewControllers(index: Int) {
        let indexesToClean = viewControllers.keys.filter { key in
            key > index + 1 || key < index - 1
        }
        indexesToClean.forEach {
            viewControllers[$0] = nil
        }
    }


}
