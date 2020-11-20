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
    
    func start() {
        let vc = OutGoingViewController.instantiate()
        vc.present(OutGoingApplyViewController(), animated: true, completion: nil)
    }
}
