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
    let viewModel = NoticeDetailViewModel()
    weak var coordinator: NoticeCoordinator?
    
    
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var notice: UITextView!
    @IBOutlet weak var previousNotice: UIButton!
    @IBOutlet weak var nextNotice: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NoticeDetailViewController {
    func bind() {
        
        
    }
}
