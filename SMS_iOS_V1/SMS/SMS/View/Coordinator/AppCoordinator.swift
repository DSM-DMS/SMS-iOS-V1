//
//  AppCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/07.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
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
    
    func start() {
        let vc = LoginViewController.instantiate(storyboardName: .login)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func tabbar() {
        let tabbarCoordinator = TabbarCoordinator(nav: nav)
        tabbarCoordinator.parentCoordinator = self
        self.children.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }
}

