//
//  OutGoingViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/10.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingViewController: UIViewController, OutGoingStoryBorded {
    
    @IBOutlet weak var outGoingApplyButton: CustomShadowButton!
    @IBOutlet weak var outGoingLogButton: CustomShadowButton!
    @IBOutlet weak var outGoingNoticeButton: CustomShadowButton!
    @IBOutlet weak var outGoingDeedButton: CustomShadowButton!
    
    
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var outGoingApplyView: UIView!
    
    let viewModel = OutGoingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let outGoingnav = UINavigationController()
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(presentingOutGoingApply))
        
        self.outGoingApplyView.addGestureRecognizer(gesture)
        
    }
    
    
    @objc func presentingOutGoingApply() {
        print("tapped")
        
        let storyboard = UIStoryboard(name: "OutGoing", bundle: nil)
        
        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let vc = storyboard.instantiateViewController(withIdentifier: "OutGoingApplyViewController")
        vc.modalPresentationStyle = .fullScreen
        
        
        rootVc?.present(vc, animated: true, completion: nil)
        
        
        
    }
    
}


