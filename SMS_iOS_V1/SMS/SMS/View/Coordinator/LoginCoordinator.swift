//
//  LoginCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/07.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

class LoginCoordinator: Coordinator {
    var finish: FinishDelegate
    var children = [Coordinator]()
    var parent: AppCoordinator!
    var nav: UINavigationController
    
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finish = finish
    }
    
    func start() {
        login()
    }
    
    func login() {
        let vc = LoginViewController.instantiate(storyboardName: .login)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func tabbar() {
        let tabbarCoordinator = TabbarCoordinator(nav: nav, finish: self.finish)
        self.children.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }
}
