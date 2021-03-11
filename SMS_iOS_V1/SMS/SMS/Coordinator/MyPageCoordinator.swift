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
    
    func pop() {
        self.nav.popViewController(animated: true)
        delegate?.dismissBar(false, nil)
    }
    
    func start() {
        let vc = MypageViewController.instantiate(storyboardName: .myPageMain)
        vc.coordinator = self
        nav.setNavigationBarHidden(true, animated: false)
        nav.pushViewController(vc, animated: false)
    }
    
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
}
