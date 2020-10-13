//
//  OutGoingViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/10.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingViewController: UIViewController {
    
    @IBOutlet weak var outGoingApplyButton: UIButton!
    @IBOutlet weak var outGoingLogButton: UIButton!
    @IBOutlet weak var outGoingNoticeButton: UIButton!
    @IBOutlet weak var outGoingDeedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowSetting()
    }
    
}

 
extension OutGoingViewController {
    func shadowSetting() {
        outGoingApplyButton.addShadow(offset: CGSize(width: 0, height: 2),
                      color: .lightGray,
                      shadowRadius: 2,
                      opacity: 0.7,
                      cornerRadius: 5)
        outGoingLogButton.addShadow(offset: CGSize(width: 0, height: 2),
                                    color: .lightGray,
                                    shadowRadius: 2,
                                    opacity: 0.7,
                                    cornerRadius: 5)
        outGoingNoticeButton.addShadow(offset: CGSize(width: 0, height: 2),
                                       color: .lightGray,
                                       shadowRadius: 2,
                                       opacity: 0.7,
                                       cornerRadius: 5)
        outGoingDeedButton.addShadow(offset: CGSize(width: 0, height: 2),
                                     color: .lightGray,
                                     shadowRadius: 2,
                                     opacity: 0.7,
                                     cornerRadius: 5)
    }

}
