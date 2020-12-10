//
//  MyPageCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MyPageCoordinator: Coordinator {
    weak var parentCoordinator: TabbarCoordinator?
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MypageViewController.instantiate(storyboardName: .myPageMain)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func disappear() {
        parentCoordinator?.disappear(self)
    }
    
    func introduce() {
        let vc = MypageIntroduceDevViewController.instantiate(storyboardName: .introduceDevlop)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
    
    func changePW() {
        let vc = MypageChangePWViewController.instantiate(storyboardName: .myPageChangePW)
        vc.coordinator = self
        nav.pushViewController(vc, animated: false)
    }
}
