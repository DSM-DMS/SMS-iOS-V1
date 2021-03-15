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
    weak var coordinator: NoticeCoordinator?
    
    let detailViewModel = NoticeDetailViewModel()
    let viewModel = NoticeViewModel()
    let disposeBag = DisposeBag()
    let detailView = NoticeDetailViewController()
    
    
    @IBOutlet weak var noticeSearchBar: UISearchBar!
    @IBOutlet weak var noticeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIbind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindAction()
    }
}



extension NoticeViewController {
    func UIbind() {
        let Notice: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
                Notice.subscribe(onNext: { model in
                    if model.status == 200 {
                        Observable.of(model.announcements ?? [])
                            .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { idx, notice, cell in
                                cell.uuid = notice.announcement_uuid
                                cell.cellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date / 1000))
                                cell.cellNumber.text = "\(notice.number)"
                                cell.cellTitle.text = notice.title
                                cell.cellViews.text = "\(notice.views)"
        
                                self.noticeSearchBar.rx.text.orEmpty
                                    .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
                                    .distinctUntilChanged()
                                    .subscribe(onNext: { t in
                                        if(notice.title.hasPrefix(t)) {
        
                                        } else {
                                            cell.isHidden = true
                                        }
        
                                    }).disposed(by: self.disposeBag)
                            }.disposed(by: self.disposeBag)
                    }
                }).disposed(by: disposeBag)
    }
    
    func bindAction() {
                noticeTableView.rx.itemSelected.bind { indexpath in
                    let cell = self.noticeTableView.cellForRow(at: indexpath) as! NoticeTableViewCell
                    UserDefaults.standard.setValue(cell.uuid!, forKey: "announcement_uuid")
                    self.detailViewModel.NoticeDetailData
                        .bind { data in
                            guard let data = try? data.content.data(using: .utf8) else { return }
                            self.detailView.blockList = try! JSONDecoder().decode(EJBlocksList.self, from: data)
                        }.disposed(by: self.disposeBag)
                    let storyboard = UIStoryboard(name: "Notice", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController")
                    self.present(vc, animated: true, completion: nil)
                }.disposed(by: disposeBag)
    }
}
