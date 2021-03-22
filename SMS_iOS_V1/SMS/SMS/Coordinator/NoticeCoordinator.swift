//
//  NoticeCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class NoticeCoordinator: Coordinator {
    var delegate: dismissBarProtocol?
    var children = [Coordinator]()
    var nav: UINavigationController
    let finishDelegate: FinishDelegate
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finishDelegate = finish
    }
    
    func main() {
        finishDelegate.main()
    }
    
    func start() {
        let vc = NoticeViewController.instantiate(storyboardName: .noticeMain)
        vc.coordinator = self
       
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "notice"), selectedImage: nil)
        vc.title = ""
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func pop() {
        self.nav.popViewController(animated: false)
        delegate?.dismissBar(false)
    }
    
    func detailNotice() {
        let vc = NoticeDetailViewController.instantiate(storyboardName: .noticeDetail)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
        delegate?.dismissBar(true)
    }
}
