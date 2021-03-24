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
    var searchText: String!
    weak var coordinator: NoticeCoordinator?
    
    @IBOutlet weak var searchTextLbl: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noticeSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextLbl.text = self.searchText
        bind()
        bindAction()
    }
}

extension NoticeSearchViewController {
    func bind() {
        let Notice: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .searchNotice(searchText))
        
        Notice.filter { $0.status == 200 }
            .map { $0.announcements ?? []}
            .bind(to: self.noticeSearchTableView.rx.items(cellIdentifier: NoticeSearchTableViewCell.NibName, cellType: NoticeSearchTableViewCell.self)) { idx, notice, cell in
                cell.uuid = notice.announcement_uuid
                cell.searchCellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date / 1000))
                cell.searchCellNum.text = "\(notice.number)"
                cell.searchCellTitle.text = notice.title
                cell.searchCellViews.text = "\(notice.views)"
                cell.selectionStyle = .none
            }.disposed(by: self.disposeBag)
    }
    
    func bindAction() {
        backButton.rx.tap
            .bind{
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        noticeSearchTableView.rx.itemSelected.bind { indexpath in
            let cell = self.noticeSearchTableView.cellForRow(at: indexpath) as! NoticeSearchTableViewCell
            self.coordinator?.detailNotice(cell.uuid!)
        }.disposed(by: disposeBag)
    }
}
