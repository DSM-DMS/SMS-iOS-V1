//
//  OutGoingLogViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class OutGoingLogViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    //    let viewModel = OutGoingLogViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
}

extension OutGoingLogViewController {
    private func bindUI() {
        let logs: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting(""))
        
        logs.map { [$0] }
            .bind(to: tableView.rx.items(cellIdentifier: OutGoingLogTableViewCell.NibName, cellType: OutGoingLogTableViewCell.self)) { idx, log, cell in
//                cell.dateLbl.text = log.
                cell.placeLbl.text = log.place
                cell.reasonLbl.text = log.reason
            
//                switch log.status {
//
//                }
            }.disposed(by: disposeBag)
    }
}
