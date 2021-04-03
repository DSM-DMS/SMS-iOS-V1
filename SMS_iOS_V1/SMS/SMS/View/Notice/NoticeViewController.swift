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
    let Notice: PublishRelay<[Announcements]> = PublishRelay()
    let disposeBag = DisposeBag()
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAnnouncements()
    }
}



extension NoticeViewController {
    func bind() {
        searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind {
                let str = self.searchTextField.text!.replacingOccurrences(of: " ", with: "")
                self.coordinator?.searchNotice(str)
            }.disposed(by: disposeBag)
        
        self.Notice
            .map { data -> [Announcements] in
                var arr: [Bool] = []
                data.forEach { data in
                    arr.append(data.noneReadingChecking())
                }
                
                if arr.contains(true) {
                    self.tabBarItem.setBadgeTextAttributes([.font: UIFont.systemFont(ofSize: 7), .foregroundColor: UIColor.red], for: .normal)
                }
                else {
                    self.tabBarItem.setBadgeTextAttributes([.font: UIFont.systemFont(ofSize: 7), .foregroundColor: UIColor.clear], for: .normal)
                }
                return data
            }
            .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { idx, notice, cell in
                cell.uuid = notice.announcement_uuid
                cell.cellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date / 1000))
                cell.cellNumber.text = "\(notice.number)"
                cell.cellTitle.text = notice.title
                cell.cellViews.text = "\(notice.views)"
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        noticeTableView.rx.itemSelected.bind { index in
            let cell = self.noticeTableView.cellForRow(at: index) as! NoticeTableViewCell
            self.coordinator?.detailNotice(cell.uuid!)
        } .disposed(by: disposeBag)
    }
    
    func getAnnouncements() {
        let announcements: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
        announcements.filter {
            if $0.status != 200 {
                self.view.makeToast("에러 발생", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
                return false
            }
            return true
        }
        .map { $0.announcements ?? [] }
        .subscribe(onNext: { data in
            self.Notice.accept(data)
        }, onError: { (error) in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
}
