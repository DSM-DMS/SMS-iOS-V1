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

class OutGoingLogViewController: UIViewController, Storyboarded, UIScrollViewDelegate, UITableViewDelegate {
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        tableView.rowHeight = 120
        tableView.rx.setDelegate(self)
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//           return 50
//       } //믿어보게
    
    
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
            case 0:
                self.cellState(cell: cell, text: "승인거부", color: .customRed)
            case 1:
                self.cellState(cell: cell, text: "승인대기", color: .customYellow)
            case 2:
                self.cellState(cell: cell, text: "승인완료", color: .customGrenn)
            case 3:
                self.cellState(cell: cell, text: "외출중", color: .customOrange)
            case 4:
                self.cellState(cell: cell, text: "만료", color: .customPurple)
            default:
                self.cellState(cell: cell, text: "에러", color: .customBlack)
            }
        }.disposed(by: disposeBag)
        
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop() }
            .disposed(by: disposeBag)
        
    }
    
    func cellState(cell: OutGoingLogTableViewCell,text: String, color: UIColor) -> OutGoingLogTableViewCell {
        cell.outGoingStateLbl.text = text
        cell.statusColorView.backgroundColor = color
        return cell
    }
}
