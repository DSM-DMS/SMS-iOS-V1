//
//  Coordinator.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/07.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var nav: UINavigationController { get set }
    
    func start()
}
