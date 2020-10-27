//
//  OutGoingApplyViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/27.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingApplyViewModel {
    
    func presentingViewController() {
        
        let rootViewController = StoryBoard.OutGoingApply.viewController
        let presentingViewController = StoryBoard.OutGoingAlert.viewController
        presentingViewController.modalPresentationStyle = .fullScreen
        rootViewController.present(presentingViewController, animated: true, completion: nil)
        
    }
}
