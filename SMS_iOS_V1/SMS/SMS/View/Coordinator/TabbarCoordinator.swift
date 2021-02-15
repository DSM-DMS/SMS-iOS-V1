//
//  TabbarCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class TabbarCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var children = [Coordinator]()
    var nav: UINavigationController
    var a = false
    
    init(nav: UINavigationController) {
        self.nav = nav
        
    }
    
    func start() {
        let vc = TabbarViewController.instantiate(storyboardName: .tabbar)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func disappear(_ child: Coordinator?) {
        for (idx, coordinator) in
            children.enumerated() {
            if coordinator === child {
                children.remove(at: idx)
                break
            }
        }
    }
    
    func outGoingMain() {
        let outGoingCoordinator = OutGoingCoordinator(nav: nav)
        self.children.append(outGoingCoordinator)
        outGoingCoordinator.parentCoordinator = self
        outGoingCoordinator.start()
    }
    
    func noticeMain() {
        let noticeCoordinator = NoticeCoordinator(nav: nav)
        self.children.append(noticeCoordinator)
        noticeCoordinator.parentCoordinator = self
        noticeCoordinator.start()
    }
    
    func myPageMain() {
        let myPageCoordinator = MyPageCoordinator(nav: nav)
        self.children.append(myPageCoordinator)
        myPageCoordinator.parentCoordinator = self
        myPageCoordinator.start()
    }
    
    func scheduleMain() {
        let scheduleCoordinator = ScheduleCoordinator(nav: nav)
        self.children.append(scheduleCoordinator)
        scheduleCoordinator.parentCoordinator = self
        scheduleCoordinator.start()
    }
}
