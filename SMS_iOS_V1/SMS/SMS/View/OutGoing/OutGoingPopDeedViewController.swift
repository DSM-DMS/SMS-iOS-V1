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
import Kingfisher

class OutGoingPopDeedViewController: UIViewController, Storyboarded {
    
    let disposeBag = DisposeBag()
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var popVCBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var studentIDLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backgroundView: CustomShadowView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "outing_uuid")
        bind()
    }
}



extension OutGoingPopDeedViewController {
    func bind() {
        popVCBtn.rx.tap
            .bind { self.coordinator?.pop()}
            .disposed(by: disposeBag)
        
        let cardModel: Observable<OutGoingCardModel> = SMSAPIClient.shared.networking(from: .lookUpOutingCard)
        
        cardModel.bind { cardData in
            let imageURL = URL(string: cardData.profile_uri)
            let dateComponent = unix(with: cardData.start_time)
            self.dateLbl.text = "\(dateComponent.year!)-\(dateComponent.month!)-\(dateComponent.day!)"
            self.timeLbl.text = "\(dateComponent.hour!):\(dateComponent.minute!)"
            self.nameLbl.text = cardData.name
            self.studentIDLbl.text = "\(cardData.grade)\(cardData.group)\(cardData.number)"
            self.profileImageView.kf.setImage(with: imageURL)
            self.placeLbl.text = cardData.place
            UserDefaults.standard.setValue(cardData.outing_uuid, forKey: "outing_uuid")
        }.disposed(by: disposeBag)
    }
}
