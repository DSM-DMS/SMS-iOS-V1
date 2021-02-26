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
    
    func pop() {
        self.nav.popViewController(animated: true)
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
    
    func checkNumber() {
        let vc = CheckCertificationNumberViewController.instantiate(storyboardName: .certificationNumber)
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
    
    func register(_ data: CertificationNumberModel, _ number: String) {
        let vc = RegisterViewController.instantiate(storyboardName: .register)
        vc.data = data
        vc.number = Int(number)
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
}

