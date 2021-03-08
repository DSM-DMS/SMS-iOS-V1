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
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
<<<<<<< HEAD:SMS_iOS_V1/SMS/SMS/Coordinator/NoticeCoordinator.swift
=======
    func disappear() {
        parentCoordinator?.disappear(self)
    }
    
    func pop() {
        self.nav.popViewController(animated: true)
    }
    
>>>>>>> Develop:SMS_iOS_V1/SMS/SMS/View/Coordinator/NoticeCoordinator.swift
    func detailNotice() {
        let vc = NoticeDetailViewController.instantiate(storyboardName: .noticeDetail)
        vc.coordinator = self
        delegate?.dismissBar(true, { [weak self] in
            self?.nav.pushViewController(vc, animated: true)
        })
    }
}
