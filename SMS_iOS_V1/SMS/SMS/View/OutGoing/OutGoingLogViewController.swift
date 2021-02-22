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
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        bindAction()
    }
}

extension OutGoingLogViewController {
    private func bindAction() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop() }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        tableView.rowHeight = 120
        
        let logs: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting)
        
        logs.map { ($0.outings ?? []) }.bind(to: tableView.rx.items(cellIdentifier: OutGoingLogTableViewCell.NibName, cellType: OutGoingLogTableViewCell.self)) { idx, log, cell in
            let startDateComponent: DateComponents = unix(with: log.start_time)
            let endDateComponent:DateComponents = unix(with: log.end_time)
            
            cell.dateLbl.text = String(startDateComponent.year!) + "-" + String(startDateComponent.month!) + "-" + String(startDateComponent.day!)
            cell.startTimeLbl.text = String(startDateComponent.hour!) + ":" + String(startDateComponent.minute!)
            cell.endTimeLbl.text = String(endDateComponent.hour!) + ":" + String(endDateComponent.minute!)
            cell.placeLbl.text = log.place
            cell.reasonLbl.text = log.reason // 셀사이의 간격 늘리기, 날짜 포멧 바꾸기 
            
            cell.emergencyImageView.isHidden = log.outing_situation == "EMERGENCY" ? false : true
            
            switch Int(log.outing_status) {
            case -1, -2:
                self.cellState(cell: cell, text: "승인 거부", color: .customRed)
            case 0, 1, 2:
                self.cellState(cell: cell, text: "승인대기", color: .customYellow)
            case 3:
                self.cellState(cell: cell, text: "외출중", color: .customOrange)
            case 4:
                self.cellState(cell: cell, text: "만료", color: .customPurple)
            case 5:
                self.cellState(cell: cell, text: "승인 완료", color: .customGreen)
            default:
                self.cellState(cell: cell, text: "에러", color: .customBlack)
            }
        }.disposed(by: disposeBag)
    }
    
    func cellState(cell: OutGoingLogTableViewCell,text: String, color: UIColor)  {
        cell.outGoingStateLbl.text = text
        cell.statusColorView.backgroundColor = color
        cell.outGoingStateLbl.textColor = color
    }
}
