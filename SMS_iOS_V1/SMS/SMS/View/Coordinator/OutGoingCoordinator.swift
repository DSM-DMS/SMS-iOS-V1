//
//  OutGoingCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingCoordinator: Coordinator {
    weak var parentCoordinator: TabbarCoordinator? 
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = OutGoingViewController.instantiate(storyboardName: .outGoingMain)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func pop() {
        self.nav.popViewController(animated: true)
    }
    
    func disappear() {
        parentCoordinator?.parentCoordinator?.disappear(self)
    }
 
    func outGoingApply() {
        let vc = OutGoingApplyViewController.instantiate(storyboardName: .outGoingApply)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func outGoingLog() {
        let vc = OutGoingLogViewController.instantiate(storyboardName: .outGoingLog)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func noticeOutGoing() {
        let vc = OutGoingNoticeViewController.instantiate(storyboardName: .outGoingNotice)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func deedOutGoing() {
        let vc = OutGoingDeedViewController.instantiate(storyboardName: .outGoingDeed)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
}
