//
//  OutGoingCompletedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingCompletedViewController: UIViewController, Storyboarded {
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var checkButton: CustomShadowButton!
    
    let viewModel = OutGoingCompletedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func checkButton(_ sender: Any) {
        viewModel.dismissingViewController()
    }
}
