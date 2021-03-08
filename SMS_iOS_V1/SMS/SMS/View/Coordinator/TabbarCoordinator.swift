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
    let finish: FinishDelegate
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finish = finish
    }
    
    func start() {
        let vc = TabbarViewController.instantiate(storyboardName: .tabbar)
        vc.finish = finish
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func outGoingMain() {
        let outGoingCoordinator = OutGoingCoordinator(nav: nav, finish: finish)
        self.children.append(outGoingCoordinator)
        outGoingCoordinator.start()
    }
    
    func noticeMain() {
        let noticeCoordinator = NoticeCoordinator(nav: nav, finish: finish)
        self.children.append(noticeCoordinator)
        noticeCoordinator.start()
    }
    
    func myPageMain() {
        let myPageCoordinator = MyPageCoordinator(nav: nav, finish: finish)
        self.children.append(myPageCoordinator)
        myPageCoordinator.start()
    }
    
    func scheduleMain() {
        let scheduleCoordinator = ScheduleCoordinator(nav: nav, finish: finish)
        self.children.append(scheduleCoordinator)
        scheduleCoordinator.start()
    }
}
