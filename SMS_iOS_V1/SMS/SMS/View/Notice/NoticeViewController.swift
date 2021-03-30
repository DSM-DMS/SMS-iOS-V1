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
import EditorJSKit

class NoticeViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        UIbind()
    }
}



extension NoticeViewController {
    func UIbind() {
        let Notice: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
        Notice.filter {
            if $0.status != 200 {
                self.view.makeToast("에러 발생")
                return false
            }
            return true
        }
        .map { ($0.announcements ?? []) }
        .subscribe(onNext: { abc in
            Observable.of(abc)
                .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { idx, notice, cell in
                    cell.uuid = notice.announcement_uuid
                    cell.cellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date / 1000))
                    cell.cellNumber.text = "\(notice.number)"
                    cell.cellTitle.text = notice.title
                    cell.cellViews.text = "\(notice.views)"
                    cell.selectionStyle = .none
                }.disposed(by: self.disposeBag)
        }, onError: { (error) in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패")
            }
        }).disposed(by: disposeBag)
    }
    
    func bindAction() {
        noticeTableView.rx.itemSelected.bind { index in
            let cell = self.noticeTableView.cellForRow(at: index) as! NoticeTableViewCell
            self.coordinator?.detailNotice(cell.uuid!)
        } .disposed(by: disposeBag)
        
        self.searchTextField.rx.text.orEmpty.bind {
            self.searchButton.isEnabled = $0 != "" ? true : false
        }.disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind {
                searchKeyword = self.searchTextField.text!
                if self.searchTextField.text! != "" {
                    self.coordinator?.searchNotice(self.searchTextField.text!)
                }
            }.disposed(by: disposeBag)
    }
}
