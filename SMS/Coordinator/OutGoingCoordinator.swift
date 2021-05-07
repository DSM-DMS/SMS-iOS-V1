//
//  OutGoingCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingCoordinator: Coordinator {
    var delegate: dismissBarProtocol?
    var children = [Coordinator]()
    var nav: UINavigationController
    let finishDelegate: FinishDelegate
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finishDelegate = finish
    }
    
    func start() {
        let vc = OutGoingViewController.instantiate(storyboardName: .outGoingMain)
        vc.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "outgoing"), selectedImage: nil)
        vc.tabBarItem.title = ""
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: true)
    }
    
    func pop() {
        self.nav.popViewController(animated: true)
        delegate?.dismissBar(false)
    }
    
    func popAll() {
        self.nav.popToRootViewController(animated: true)
        delegate?.dismissBar(false)
    }
    
    func main() {
        finishDelegate.main()
    }
    
    func outGoingApply() {
        let vc = OutGoingApplyViewController.instantiate(storyboardName: .outGoingApply)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: true)
        delegate?.dismissBar(true)
    }
    
    func outGoingLog() {
        let vc = OutGoingLogViewController.instantiate(storyboardName: .outGoingLog)
        vc.coordinator = self
        delegate?.dismissBar(true)
        self.nav.pushViewController(vc, animated: true)
    }
    
    func noticeOutGoing() {
        let vc = OutGoingNoticeViewController.instantiate(storyboardName: .outGoingNotice)
        vc.coordinator = self
        delegate?.dismissBar(true)
        self.nav.pushViewController(vc, animated: true)
    }
    
    func outGoingPopDeed() {
        let vc = OutGoingPopDeedViewController.instantiate(storyboardName: .outGoingDeed)
        vc.coordinator = self
        delegate?.dismissBar(true)
        self.nav.pushViewController(vc, animated: true)
    }
    
    func outGoingCompleted(_ code: Int) {
        let vc = OutGoingCompletedViewController.instantiate(storyboardName: .outGoingCompleted)
        vc.coordinator = self
        vc.text = code
        delegate?.dismissBar(true)
        self.nav.pushViewController(vc, animated: true)
    }
}
