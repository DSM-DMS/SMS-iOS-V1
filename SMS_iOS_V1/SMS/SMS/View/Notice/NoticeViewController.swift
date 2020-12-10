//
//  NoticeViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController, Storyboarded {
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
    
}
