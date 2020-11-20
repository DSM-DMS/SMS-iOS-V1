//
//  OutGoingCoordinator.swift
//  SMS
//
//  Created by DohyunKim on 2020/11/20.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import Foundation
import UIKit

class OutGoingCoordinator: Coordinator{
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = OutGoingViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func presentingOutGoingApply() {
        let vc = OutGoingApplyViewController.instantiate()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(vc, animated: true)
    }
    
}
