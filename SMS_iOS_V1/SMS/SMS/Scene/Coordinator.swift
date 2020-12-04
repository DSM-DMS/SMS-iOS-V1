//
//  Coordinator.swift
//  SMS
//
//  Created by DohyunKim on 2020/11/19.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
