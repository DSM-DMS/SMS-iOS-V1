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
        //        bindAction()
        
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
                        cell.cellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date))
                        cell.cellNumber.text = "\(notice.number)"
                        if(notice.title.count >= 18) {
                            let titleArr = Array(notice.title)
                            var noticeTitle = ""
                            for i in 0..<16 {
                                noticeTitle.append(titleArr[i])
                            }
                            noticeTitle.append("...")
                            cell.cellTitle.text = noticeTitle
                        } else {
                            cell.cellTitle.text = notice.title
                        }
                        
                        cell.cellViews.text = "\(notice.views)"
                    }.disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func bindAction() {
        noticeTableView.rx.itemSelected.bind { indexpath in
            let cell = self.noticeTableView.cellForRow(at: indexpath) as! NoticeTableViewCell
            UserDefaults.standard.setValue(cell.uuid!, forKey: "announcement_uuid")
            let storyboard = UIStoryboard(name: "Notice", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NoticeDetailViewController")
            self.present(vc, animated: true, completion: nil)
            
        }.disposed(by: disposeBag)
        
        
        
    }
    
    
    
}
