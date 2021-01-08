//
//  AppDelegate.swift
//  SMS
//
//  Created by 이현욱 on 2020/09/03.
//  Copyright © 2020 이현욱. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: AppCoordinator? 
    var window:UIWindow?
    // keychain이 저장되어있는지, 와이파이 잡혀있는지 체크 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let nav = UINavigationController()
        coordinator = AppCoordinator(nav: nav)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
}
