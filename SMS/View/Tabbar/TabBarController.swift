//
//  TabBarController.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/18.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

protocol dismissBarProtocol {
    func dismissBar(_ value: Bool)
}

import UIKit

class TabBarController: UITabBarController, Storyboarded {
    var value: Bool = false
    var finish: FinishDelegate!
    weak var coordinator: TabbarCoordinator!
    
    lazy var scheduleCoordinator = ScheduleCoordinator(nav: UINavigationController(), finish: finish)
    lazy var outGoingCoordinator = OutGoingCoordinator(nav: UINavigationController(), finish: finish)
    lazy var noticeCoordinator = NoticeCoordinator(nav: UINavigationController(), finish: finish)
    lazy var myPageCoordinator = MyPageCoordinator(nav: UINavigationController(), finish: finish)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTabbar()
        settingDelegate()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.tintColor = .customPurple
    }
}



extension TabBarController {
    func settingDelegate() {
        self.delegate = self
        outGoingCoordinator.delegate = self
        noticeCoordinator.delegate = self
        myPageCoordinator.delegate = self
    }
    
    func settingTabbar() {
        self.tabBar.barTintColor = .tabbarColor
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        scheduleCoordinator.start()
        outGoingCoordinator.start()
        noticeCoordinator.start()
        myPageCoordinator.start()
        self.viewControllers = [scheduleCoordinator.nav, outGoingCoordinator.nav, noticeCoordinator.nav, myPageCoordinator.nav]
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if !value {
            if gesture.direction == .left {
                if (self.selectedIndex) < 3 {
                    animateToTab(toIndex: self.selectedIndex+1)
                }
            } else if gesture.direction == .right {
                if (self.selectedIndex) > 0 {
                    animateToTab(toIndex: self.selectedIndex-1)
                }
            }
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
              let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
              let toView = tabViewControllers[toIndex].view,
              let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
              fromIndex != toIndex else { return }
        
        fromView.superview?.addSubview(toView)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
                        
                       }, completion: { finished in
                        fromView.removeFromSuperview()
                        self.selectedIndex = toIndex
                        self.view.isUserInteractionEnabled = true
                       })
    }
}



extension TabBarController: dismissBarProtocol {
    func dismissBar(_ value: Bool) {
        self.value = value
        self.tabBar.isHidden = value
    }
}
