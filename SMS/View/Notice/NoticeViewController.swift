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
import RxViewController

class NoticeViewController: UIViewController, Storyboarded {
    let Notice = PublishSubject<[Announcements]>()
    let disposeBag = DisposeBag()
    let viewModel = NoticeViewModel(networking: SMSAPIClient.shared)
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}



extension NoticeViewController {
    func bind() {
        self.rx.viewDidAppear.map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)
        
        noticeTableView.rx.itemSelected.bind { index in
            let cell = self.noticeTableView.cellForRow(at: index) as! NoticeTableViewCell
            self.coordinator?.detailNotice(cell.uuid!)
        } .disposed(by: disposeBag)
        
        searchTextField.rx
            .controlEvent(.editingDidEndOnExit)
            .bind {
                let str = self.searchTextField.text!.replacingOccurrences(of: " ", with: "")
                if !str.isEmpty { self.coordinator?.searchNotice(str) }
            }.disposed(by: disposeBag)
        
        viewModel.output.announcements.filter {
            if $0.status != 200 {
                self.view.makeToast("에러 발생", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
                return false
            }
            return true
        }
        .map { $0.announcements ?? [] }
        .subscribe(onNext: { data in
            self.Notice.onNext(data)
        }, onError: { (error) in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }
        ).disposed(by: disposeBag)
        
        Notice.map { data -> [Announcements] in
            var arr: [Bool] = []
            data.forEach { data in
                arr.append(data.noneReadingChecking())
            }
            
            let color: UIColor = arr.contains(true) ? .red : .clear
            self.tabBarItem.setBadgeTextAttributes([.font: UIFont.systemFont(ofSize: 7), .foregroundColor: color], for: .normal)
            
            return data
        }
        .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { _, notice, cell in
            cell.setting(notice)
        }.disposed(by: self.disposeBag)
    }
}
