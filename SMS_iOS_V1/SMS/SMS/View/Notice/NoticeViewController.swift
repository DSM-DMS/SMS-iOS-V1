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
    let searchView = NoticeSearchViewController()
    
    
    
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
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
        
        self.searchButton.isEnabled = false
        
        //                 테스트 코드 입니다.
        //        var testArr = ["안녕하세요", "하이하이", "방가방가"]
        //        let emptyArr = ["안녕못해요"]
        //        Observable.of(testArr)
        //            .bind(to: noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName, cellType: NoticeTableViewCell.self)) { idx, info, cell in
        //                cell.cellTitle.text = info
        //                self.searchButton.rx.tap
        //                    .bind {
        //                        print("asdasdasdasddadsdasdasdadasdasd")
        //                        testArr = emptyArr
        //                        self.noticeTableView.reloadData()
        //                        print(testArr)
        //                    }.disposed(by: self.disposeBag)
        //
        ////                self.noticeSearchBar.rx.text.orEmpty
        ////                    .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
        ////                    .distinctUntilChanged()
        ////                    .subscribe(onNext: { t in
        ////
        ////                        testArr = emptyArr
        ////                        self.noticeTableView.reloadData()
        ////                        //                        if(info.hasPrefix(t)) {
        ////                        //
        ////                        //                        } else {
        ////                        //                            cell.isHidden = true
        ////                        //}
        ////
        ////
        ////                    }).disposed(by: self.disposeBag)
        //            }.disposed(by: disposeBag)
        //
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
                        
                        //                                        self.noticeSearchBar.rx.text.orEmpty
                        //                                            .debounce(RxTimeInterval.milliseconds(5), scheduler: MainScheduler.instance)
                        //                                            .distinctUntilChanged()
                        //                                            .subscribe(onNext: { t in
                        //                                                if(notice.title.hasPrefix(t)) {
                        //
                        //                                                } else {
                        //                                                    cell.isHidden = true
                        //                                                }
                        //
                        //                                            }).disposed(by: self.disposeBag)
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
        
       
        let searchTextFieldObservable = self.searchTextField.rx.text.orEmpty
        
        searchTextFieldObservable.subscribe(onNext: { _ in
            if self.searchTextField.text != "" {
                self.searchButton.isEnabled = true
            } else {
                self.searchButton.isEnabled = false
            }
        }).disposed(by: disposeBag)
        
       

        
        searchButton.rx.tap
            .bind {
                
                searchKeyword = self.searchTextField.text!
                let storyboard = UIStoryboard(name: "Notice", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "NoticeSearchViewController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        
        
    }
    
    
    
}
