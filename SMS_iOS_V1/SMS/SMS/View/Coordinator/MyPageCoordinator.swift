//
//  MyPageCoordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/08.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class MyPageCoordinator: Coordinator {
    var delegate: dismissBarProtocol?
    weak var parentCoordinator: TabbarCoordinator?
    var children = [Coordinator]()
    var nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MypageViewController.instantiate(storyboardName: .myPageMain)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
    func disappear() {
        parentCoordinator?.disappear(self)
    }
    
    func pop() {
        self.nav.popViewController(animated: true)
    }
    
    func introduce() {
        let vc = MypageIntroduceDevViewController.instantiate(storyboardName: .introduceDevlop)
        vc.coordinator = self
        delegate?.dismissBar(true)
        nav.pushViewController(vc, animated: false)
    }
    
    func changePW() {
        let vc = MypageChangePWViewController.instantiate(storyboardName: .myPageChangePW)
        vc.coordinator = self
        delegate?.dismissBar(true)
        nav.pushViewController(vc, animated: false)
    }
    
    func logout() {
        let vc = MypageLogoutViewController.instantiate(storyboardName: .myPageLogout)
        vc.coordinator = self
        delegate?.dismissBar(true)
        nav.pushViewController(vc, animated: false)
    }
    
    func pwConfirm() {
        let vc = MypageChangePWAlertViewController.instantiate(storyboardName: .mypageChangePWAlert)
        vc.coordinator = self
        delegate?.dismissBar(true)
        nav.pushViewController(vc, animated: false)
        
    }
}
