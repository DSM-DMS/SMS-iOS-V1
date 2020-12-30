//
//  OutGoingLocationXib.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingLocationAlertView: UIView {
    let disposeBag = DisposeBag()
    var sign: ((String) -> ())? = nil
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(OutGoingAlertXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        bindAction()
        bind()
    }
}

extension OutGoingLocationAlertView {
    func bindAction() {
        cancelBtn.rx.tap
            .bind { self.coordinator?.pop() }
            .disposed(by: disposeBag)
    }
    
    func bind() {
        tableView.rowHeight = 70
        locationSearchBar.rx.searchButtonClicked
            .map { self.locationSearchBar.text! }
            .distinctUntilChanged()
            .flatMap { txt -> Observable<OutLocationModel> in
                SMSAPIClient.shared.networking(from: .location(txt))
            }.map { model in
                model.item!
            }.bind(to: tableView.rx.items(cellIdentifier: LocationTableViewCell.NibName, cellType: LocationTableViewCell.self)) { _, address, cell in
                cell.addressLbl.text = address.address
                cell.roadAddressLbl.text = address.roadAddress
            }.disposed(by: disposeBag)
        
        Observable.zip(self.tableView.rx.itemSelected, self.tableView.rx.modelSelected(itmesArr.self))
            .bind { [unowned self] _, model in
                sign?(model.address)
                self.coordinator?.pop()
            }.disposed(by: self.disposeBag)
    }
}
