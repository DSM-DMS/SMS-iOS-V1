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
        People.init(name: "이성진", part: "Front", image: "성진"),
        People.init(name: "공영길", part: "Front", image: "영길"),
        People.init(name: "박진홍", part: "PM/Backend", image: "진홍"),
        People.init(name: "손민기", part: "Backend", image: "민기"),
        People.init(name: "이현욱", part: "iOS", image: "현욱"),
        People.init(name: "김도현", part: "iOS", image: "도현"),
        People.init(name: "윤석준", part: "Android", image: "석준"),
        People.init(name: "유재민", part: "Android", image: "재민"),
        People.init(name: "강신희", part: "Design", image: "신희"),
        People.init(name: "용석현", part: "Design", image: "석현")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        bindAction()
        setting()
        devCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension MypageIntroduceDevViewController: UIScrollViewDelegate {
    func bind() {
        Observable.of(peopleArr)
            .bind(to: devCollectionView.rx.items(cellIdentifier: DevCollectionViewCell.NibName, cellType: DevCollectionViewCell.self)) { _, people, cell in
                cell.imageView.image = UIImage(named: people.image)
                cell.imageView.layer.cornerRadius = cell.imageView.frame.height / 1.95
                cell.nameLbl.text = people.name
                cell.partLbl.text = people.part
            }.disposed(by: disposeBag)
    }
    
    func bindAction() {
        backButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
    }
    
    func setting() {
        let flowLayout = UICollectionViewFlowLayout()
        let height = UIScreen.main.bounds.height / 3.76
        let width = UIScreen.main.bounds.width / 2.9
        flowLayout.itemSize = CGSize(width: width, height: height)
        devCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}

struct People {
    var name: String
    var part: String
    var image: String
}

