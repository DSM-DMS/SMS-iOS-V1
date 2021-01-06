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
    }
}

extension OutGoingLocationAlertXib {
    func bind() {
        tableView.rowHeight = 70
        tableView.register(LocationTableViewCell.self)
        
        locationSearchBar.rx.searchButtonClicked
            .map { self.locationSearchBar.text! }
            .filter { txt in
                txt != "" || !txt.isEmpty
            }
            .distinctUntilChanged()
            .flatMap { txt -> Observable<OutLocationModel> in
                SMSAPIClient.shared.networking(from: .location(txt))
            }.map { model in
                model.item!
            }.bind(to: tableView.rx.items(cellIdentifier: LocationTableViewCell.NibName, cellType: LocationTableViewCell.self)) { _, detail, cell in
                cell.contentView.backgroundColor = .white
                cell.addressLbl.text = detail.address
                cell.roadAddressLbl.text = detail.roadAddress
            }.disposed(by: disposeBag)
        
    }
}

