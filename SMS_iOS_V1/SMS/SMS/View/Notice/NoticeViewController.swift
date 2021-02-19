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
        UIbind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}



extension NoticeViewController {
    func UIbind() {
        let Notice: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
        Notice.subscribe(onNext: { model in
            if model.status == 200 {
                Observable.of(model.announcements ?? [])
                    .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { idx, notice, cell in
                        cell.cellDate.text = unix(with: notice.date)
                        cell.cellNumber.text = "\(notice.number)"
                        cell.cellTitle.text = notice.title
                        cell.cellViews.text = "\(notice.views)"
                    }.disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
    }
}
