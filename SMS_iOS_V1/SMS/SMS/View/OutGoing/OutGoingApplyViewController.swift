//
//  OutGoingApplyViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/11.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
class OutGoingApplyViewController: UIViewController, Storyboarded {
    weak var coordinator: OutGoingCoordinator?

    @IBOutlet weak var applyButton: CustomShadowButton!
    
    let viewModel = OutGoingApplyViewModel()
    
//    weak var coordinator: OutGoingCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func applyButton(_ sender: Any) {
//        viewModel.presentingViewController()
        
    }
    @IBAction func backButton(_ sender: Any) {
//        viewModel.dismissingViewController()
    }
}
