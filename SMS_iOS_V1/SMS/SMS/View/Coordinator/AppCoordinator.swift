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
    
    func start() {
        login()
    }
    
    func login() {
        let loginCoordinator = LoginCoordinator(nav: nav, finish: self)
        self.children.append(loginCoordinator)
        loginCoordinator.start()
    }
}

extension AppCoordinator: FinishDelegate {
    func main() {
        login()
    }
}
