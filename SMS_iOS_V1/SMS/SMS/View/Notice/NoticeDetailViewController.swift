//
//  NoticeDetailViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/23.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class NoticeDetailViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var viewsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NoticeDetailViewController {
    func bind() {
        
        
    }
}
