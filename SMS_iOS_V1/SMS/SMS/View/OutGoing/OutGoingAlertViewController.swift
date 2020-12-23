//
//  OutGoingAlertViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingAlertViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var backgroundView: CustomShadowButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var applicationBtn: UIButton!
    
    let viewModel = OutGoingAlertViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension OutGoingAlertViewController {
    func bindAction() {
        cancelBtn.rx.tap
            .bind { }
            .disposed(by: disposeBag)
        
        applicationBtn.rx.tap
            .bind {}
            .disposed(by: disposeBag)
    }
}

class OutGoingLocationAlertViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
}

extension OutGoingLocationAlertViewController {
    func bindAction() {
        cancelBtn.rx.tap
            .bind {}
            .disposed(by: disposeBag)
    }
    
    func bind() {
        locationSearchBar.rx.text
            .map { $0 ?? "" }
            .flatMap { txt -> Observable<OutLocationModel> in
                SMSAPIClient.shared.networking(from: .location(txt!))
            }.map { model in
                model.item
            }.bind(to: tableView.rx.items(cellIdentifier: LocationTableViewCell.NibName, cellType: LocationTableViewCell.self)) { _, address, cell in
                cell.addressLbl.text = address.address
                cell.roadAddressLbl.text = address.roadAddress
            }.disposed(by: disposeBag)
    }
}
