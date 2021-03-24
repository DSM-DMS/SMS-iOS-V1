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

class NoticeSearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    
    
    let detailView = NoticeDetailViewController()
    let detailViewModel = NoticeDetailViewModel()
    
    var searchAnnounceMent: [Announcements] = []
    
    
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var noticeSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        bindAction()
        
    }
    
    
}

extension NoticeSearchViewController {
    
    func bind() {
        
        let Notice: Observable<NoticeModel> = SMSAPIClient.shared.networking(from: .lookUpNotice)
        
        Notice.subscribe(onNext: { model in
            if model.status == 200 {
                Observable.of(model.announcements ?? [])
                    .subscribe(onNext: { announcement in
                        print(announcement)
                        let count = announcement.count
                        if count != 0 {
                            
                            for i in 0...count - 1{
                                if announcement[i].title.hasPrefix(searchKeyword) {
                                    self.searchAnnounceMent.append(announcement[i])
                                }
                                
                            }
                        }
                    }).disposed(by: self.disposeBag)
            }
            
        }).disposed(by: disposeBag)
        // 공지 없을때랑 키워드 비었을때 처리해야함.
        Observable.of(searchAnnounceMent)
            .bind(to:
                    self.noticeSearchTableView.rx.items(cellIdentifier: NoticeSearchTableViewCell.NibName, cellType: NoticeSearchTableViewCell.self)) { idx, notice, cell in
                cell.searchCellTitle.text = notice.title
                cell.searchCellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date))
                cell.searchCellNum.text = "\(notice.number)"
                cell.searchCellViews.text = "\(notice.views)"
            }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        backButton.rx.tap
            .bind{
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        noticeSearchTableView.rx.itemSelected.bind { indexpath in
            let cell = self.noticeSearchTableView.cellForRow(at: indexpath) as! NoticeSearchTableViewCell
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
