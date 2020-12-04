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
    
    @IBOutlet weak var outGoingApplyView: UIView!
    
    let viewModel = OutGoingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentingOutGoingApply))
        
        self.outGoingApplyView.addGestureRecognizer(gesture)
        
    }
    
    @objc func presentingOutGoingApply() {
        let storyboard = UIStoryboard(name: "OutGoing", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "OutGoingApplyViewController")
        
        self.navigationController!.pushViewController(vc, animated: true)

       
        
    }
    

 


}
