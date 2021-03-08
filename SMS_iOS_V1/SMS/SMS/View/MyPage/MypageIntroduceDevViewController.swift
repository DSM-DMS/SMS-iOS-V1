//
//  MypageIntroduceDevViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MypageIntroduceDevViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var devCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    let peopleArr: [People] = [
        People.init(name: "이성진", part: "Front", image: "성진.jpg"),
        People.init(name: "공영길", part: "Front", image: "영길.jpg"),
        People.init(name: "박진홍", part: "PM/Backend", image: "진홍.jpg"),
        People.init(name: "손민기", part: "Backend", image: "민기.jpg"),
        People.init(name: "김도현", part: "iOS", image: "도현.jpg"),
        People.init(name: "이현욱", part: "iOS", image: "현욱.jpg"),
        People.init(name: "윤석준", part: "Android", image: "석준.jpg"),
        People.init(name: "유재민", part: "Android", image: "재민.jpg"),
        People.init(name: "강신희", part: "Design", image: "신희.jpg"),
        People.init(name: "용석현", part: "Design", image: "석현.jpg")
    ]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
    }
    
    
}

extension MypageIntroduceDevViewController {
    func bind() {
        Observable.just(peopleArr)
            .bind(to: devCollectionView.rx.items(cellIdentifier: DevCollectionViewCell.NibName)) { _, people, cell in
                if let cellToUse = cell as? DevCollectionViewCell {
//                    cellToUse.imageView.image = UIImage(named: people.image)
//                    cellToUse.nameLbl.text = people.name
//                    cellToUse.partLbl.text = people.part
                }
            }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        backButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
    
    
}

struct People {
    var name: String
    var part: String
    var image: String
}

