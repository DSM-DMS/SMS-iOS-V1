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
    var children = [Coordinator]()
    var nav: UINavigationController
    let finishDelegate: FinishDelegate
    
    init(nav: UINavigationController, finish: FinishDelegate) {
        self.nav = nav
        self.finishDelegate = finish
    }
    
    func main() {
        finishDelegate.main()
    }
    
    func start() {
        let vc = MypageViewController.instantiate(storyboardName: .myPageMain)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
<<<<<<< HEAD:SMS_iOS_V1/SMS/SMS/Coordinator/MyPageCoordinator.swift
=======
    func disappear() {
        parentCoordinator?.disappear(self)
    }
    
    func pop() {
        self.nav.popViewController(animated: true)
    }
    
>>>>>>> Develop:SMS_iOS_V1/SMS/SMS/View/Coordinator/MyPageCoordinator.swift
    func introduce() {
        let vc = MypageIntroduceDevViewController.instantiate(storyboardName: .introduceDevlop)
        vc.coordinator = self
        delegate?.dismissBar(true, { [weak self] in
            self?.nav.pushViewController(vc, animated: true)
        })
    }
    
    func changePW() {
        let vc = MypageChangePWViewController.instantiate(storyboardName: .myPageChangePW)
        vc.coordinator = self
        delegate?.dismissBar(true, { [weak self] in
            self?.nav.pushViewController(vc, animated: true)
        })
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
