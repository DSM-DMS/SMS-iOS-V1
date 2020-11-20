//
//  OutGoingViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/10.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingViewController: UIViewController, OutGoingStoryBorded {
    
    weak var coordinator: OutGoingCoordinator?
    
    let viewModel = OutGoingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goApplyBtn(_ sender: Any) {
        print("tapped")
        coordinator?.presentingOutGoingApply()
    }
    

 


}
