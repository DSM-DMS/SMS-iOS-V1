//
//  NoticeViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoticeViewController: UIViewController, Storyboarded {
    weak var coordinator: NoticeCoordinator?
    
    let viewModel = NoticeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchTextField: UIView!
    @IBOutlet weak var noticeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
    
}
extension NoticeViewController {
    
    func bind() {
        viewModel.noticeData.subscribe { data in
            data.element?.
//            if data.element?.status == 200 || data.element?.code == 200 {
//
//                noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName)
//
//
//            }
            
        }.disposed(by: disposeBag)
    }
}
