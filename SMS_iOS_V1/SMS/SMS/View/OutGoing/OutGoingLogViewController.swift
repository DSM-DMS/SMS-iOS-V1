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
import Toast_Swift
import RxViewController

class OutGoingLogViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = OutGoingLogViewModel(network: SMSAPIClient.shared, count: 0)
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var notExistLogView: UIView!
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        tableView.rowHeight = 146
    }
}



extension OutGoingLogViewController {
    private func bind() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop() }
            .disposed(by: disposeBag)
        
        viewModel.response.filter {
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
        }.subscribe { model in
            Observable.of(model)
                .bind(to: self.tableView.rx.items(cellIdentifier: OutGoingLogTableViewCell.NibName, cellType: OutGoingLogTableViewCell.self)) { idx, log, cell in
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
                    
                    let timeCheck = unix(with: log.end_time) > Date()
                    
                    switch Int(log.outing_status) {
                    case -1, -2:
                        if timeCheck {
                            self.cellState(cell: cell, text: "승인 거부", color: .customOrange)
                        } else {
                            self.cellState(cell: cell, text: "만료", color: .customRed)
                        }
                    case 0, 1:
                        if timeCheck {
                            self.cellState(cell: cell, text: "승인대기", color: .customYellow)
                        } else {
                            self.cellState(cell: cell, text: "만료", color: .customRed)
                        }
                    case 2:
                        if timeCheck {
                            self.cellState(cell: cell, text: "외출 가능", color: .customGreen)
                        } else {
                            self.cellState(cell: cell, text: "만료", color: .customRed)
                        }
                    case 3:
                        self.cellState(cell: cell, text: "외출중", color: .customPurple)
                    case 4:
                        self.cellState(cell: cell, text: "선생님 방문 필요", color: .customRed)
                    case 5:
                        self.cellState(cell: cell, text: "외출 확인 완료", color: .customBlue)
                    default:
                        self.cellState(cell: cell, text: "에러", color: .customBlack)
                    }
                }.disposed(by: self.disposeBag)
            
        } onError: { error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
    
    func cellState(cell: OutGoingLogTableViewCell,text: String, color: UIColor)  {
        cell.outGoingStateLbl.text = text
        cell.statusColorView.backgroundColor = color
        cell.outGoingStateLbl.textColor = color
    }
}
