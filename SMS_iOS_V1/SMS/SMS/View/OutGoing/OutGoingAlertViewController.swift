//
//  OutGoingAlertViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingAlertViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: CustomShadowButton!
    
    let viewModel = OutGoingAlertViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func cancelButton(_ sender: Any) {
//        viewModel.dismissViewController()
    }
    @IBAction func applyButton(_ sender: Any) {
//        viewModel.presentViewController()
    }
}
