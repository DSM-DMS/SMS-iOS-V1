//
//  ScheduleCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/09.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class ScheduleCoordinator: Coordinator {
    weak var parentCoordinator: TabbarCoordinator?
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = ScheduleViewController.instantiate(storyboardName: .schedule)
        vc.coordinator = self
        self.nav.pushViewController(vc, animated: false)
    }
    
    func disappear() {
        parentCoordinator?.disappear(self)
    }
}
