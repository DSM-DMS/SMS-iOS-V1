//
//  NoticeCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class NoticeCoordinator: Coordinator {
    weak var parentCoordinator: TabbarCoordinator?
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = NoticeViewController.instantiate(storyboardName: .noticeMain)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func disappear() {
        parentCoordinator?.disappear(self)
    }
    
    func detailNotice() {
        let vc = NoticeDetailViewController.instantiate(storyboardName: .noticeDetail)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
}
