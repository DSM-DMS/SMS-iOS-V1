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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        tableView.rowHeight = 120
    }
}

extension OutGoingLogViewController {
    private func bindUI() {
        let logs: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting)
        
        logs.map { ($0.outings ?? []) }.bind(to: tableView.rx.items(cellIdentifier: OutGoingLogTableViewCell.NibName, cellType: OutGoingLogTableViewCell.self)) { idx, log, cell in
            cell.startTimeLbl.text = UnixStampToDate(with: log.start_time)
            cell.endTimeLbl.text = UnixStampToDate(with: log.end_time)
            cell.placeLbl.text = log.place
            cell.reasonLbl.text = log.reason
            switch Int(log.outing_status) {
            
            case .none:
                <#code#>
            case .some(_):
                <#code#>
            }
        }.disposed(by: disposeBag)
    }
}
