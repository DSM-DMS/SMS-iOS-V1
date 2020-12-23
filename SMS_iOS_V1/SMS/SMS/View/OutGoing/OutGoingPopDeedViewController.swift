//
//  OutGoingPopDeedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class OutGoingPopDeedViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    var data: CardData?
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var studentIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var popAlertBtn: UIButton!
    @IBOutlet weak var backgroundView: CustomShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension OutGoingPopDeedViewController {
    func bind() {
        popAlertBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
//        dateLbl.text = data?.date.year
        nameLbl.text = data?.name
        studentIDLbl.text = data?.studentID
    }
}


struct CardData {
    let studentID: String
    let name: String
    let date: DateComponents
}
