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
    
    @IBOutlet weak var notExistLogView: UIView!
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
        
        let logs: Observable<OutGoingLogModel> = SMSAPIClient.shared.networking(from: .lookUpAllOuting(0,0))
        
        logs.filter {
            if $0.status == 401 {
                self.coordinator?.main()
                return false
            }
            return true
        }
        .filter {
            if $0.outings?.count == 0 {
                self.notExistLogView.isHidden = false
                return false
            }
            return true
        }.map {
            return $0.outings!
        }.bind(to: tableView.rx.items(cellIdentifier: OutGoingLogTableViewCell.NibName, cellType: OutGoingLogTableViewCell.self)) { idx, log, cell in
            let startDateComponent: DateComponents = unix(with: log.start_time)
            let endDateComponent: DateComponents = unix(with: log.end_time)
            
            cell.dateLbl.text = String(startDateComponent.year!) + "-" + String(startDateComponent.month!) + "-" + String(startDateComponent.day!)
            
            let zeroForStart = startDateComponent.minute! < 10 ? "0" : ""
            let zeroForEnd = endDateComponent.minute! < 10 ? "0" : ""
            
            cell.startTimeLbl.text = String(startDateComponent.hour!) + ":" + zeroForStart + String(startDateComponent.minute!)
            cell.endTimeLbl.text = String(endDateComponent.hour!) + ":" + zeroForEnd + String(endDateComponent.minute!)
            cell.placeLbl.text = log.place
            cell.reasonLbl.text = log.reason
            
            cell.emergencyImageView.isHidden = log.outing_situation == "EMERGENCY" ? false : true
            
            switch Int(log.outing_status) {
            case -1, -2:
                self.cellState(cell: cell, text: "승인 거부", color: .customOrange)
            case 0, 1:
                self.cellState(cell: cell, text: "승인대기", color: .customYellow)
            case 2:
                self.cellState(cell: cell, text: "외출 가능", color: .customGreen)
            case 3:
                self.cellState(cell: cell, text: "외출중", color: .customPurple)
            case 4:
                self.cellState(cell: cell, text: "선생님 방문 인증 필요", color: .customRed)
            case 5:
                self.cellState(cell: cell, text: "외출 확인 완료", color: .blue)
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
