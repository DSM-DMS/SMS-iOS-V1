//
//  ScheduleCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/09.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit


protocol FinishDelegate {
    func main()
}

class ScheduleCoordinator: Coordinator {
    var finishDelegate: FinishDelegate!
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finishDelegate = finish
    }
    
    func start() {
        let vc = ScheduleViewController.instantiate(storyboardName: .schedule)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        self.nav.pushViewController(vc, animated: false)
    }
    
    func main() {
        finishDelegate.main()
    }
}
