//
//  OutGoingLocationAlertXib.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Toast_Swift

class OutGoingLocationAlertXib: UIView {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(OutGoingLocationAlertXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bind()
        setting()
    }
}

extension OutGoingLocationAlertXib {
    func setting() {
        locationSearchBar.barTintColor = .tabbarColor
        tableView.backgroundColor = .tabbarColor
        tableView.rowHeight = 70
        tableView.register(LocationTableViewCell.self)
    }
    
    func bind() {
        locationSearchBar.rx.searchButtonClicked
            .map { self.locationSearchBar.text! }
            .filter { txt in
                txt != "" || !txt.isEmpty
            }
            .distinctUntilChanged()
            .flatMap { txt -> Observable<OutLocationModel> in
                SMSAPIClient.shared.networking(from: .location(txt))
            }.filter { model in
                let windows = UIApplication.shared.windows
                if model.status == 423 {
                    windows.last?.makeToast("조금만 기다려주세요.",
                                            point: CGPoint(x: self.frame.midX,
                                                           y: self.bounds.size.height + 60),
                                            title: nil,
                                            image: nil,
                                            completion: nil)
                }
                
                if model.item?.count == 0 {
                    windows.last?.makeToast("검색 결과가 없습니다. 도로명이나 지역명을 이용해서 검색하세요.",
                                            point: CGPoint(x: self.frame.midX,
                                                           y: self.bounds.size.height + 60),
                                            title: nil,
                                            image: nil,
                                            completion: nil)
                }
                return true
            }.map { model in
                model.item ?? []
            }
            .bind(to: tableView.rx.items(cellIdentifier: LocationTableViewCell.NibName, cellType: LocationTableViewCell.self)) { _, detail, cell in
                cell.contentView.backgroundColor = .white
                cell.addressLbl.text = detail.address
                cell.roadAddressLbl.text = detail.roadAddress
                self.locationSearchBar.resignFirstResponder()
            }.disposed(by: disposeBag)
    }
}

