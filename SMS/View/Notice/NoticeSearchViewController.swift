//
//  NoticeSearchViewController.swift
//  SMS
//
//  Created by DohyunKim on 2021/03/15.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import EditorJSKit

class NoticeSearchViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = NoticeSearchViewModel(networking: SMSAPIClient.shared)
    var searchText: String = ""
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var searchTextLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noticeSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextLbl.text = self.searchText
        bind()
    }
}

extension NoticeSearchViewController {
    func bind() {
        Observable.just(searchText)
            .bind {
                self.viewModel.input.searchTextSubject.onNext($0)
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind{
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        noticeSearchTableView.rx.itemSelected.bind { indexpath in
            let cell = self.noticeSearchTableView.cellForRow(at: indexpath) as! NoticeSearchTableViewCell
            self.coordinator?.detailNotice(cell.uuid!)
        }.disposed(by: disposeBag)
        
        viewModel.output.announcements
            .filter { $0.status == 200 }
            .map { $0.announcements ?? []}
            .bind(to: self.noticeSearchTableView.rx.items(cellIdentifier: NoticeSearchTableViewCell.NibName, cellType: NoticeSearchTableViewCell.self)) { _, notice, cell in
                cell.setting(notice)
            }.disposed(by: self.disposeBag)
    }
}
