//
//  OutGoingAlertViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/27.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingAlertViewModel {
    
    func presentViewController() {
        let rootViewController = StoryBoard.OutGoingAlert.viewController
        let presentingViewController = StoryBoard.OutGoingCompleted.viewController
        presentingViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(presentingViewController, animated: true, completion: nil)
    }
    
}
