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
    weak var coordinator: MyPageCoordinator?
    

    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var devName: UILabel!
    @IBOutlet weak var devPart: UILabel!
    @IBOutlet weak var devCollectionView: UICollectionView!
    
    
    
    let disposeBag = DisposeBag()
    
    let peopleArr: Array = [
        
        People.init(name: "이성진", part: "PM/Front", image: "성진.jpg"),
        People.init(name: "공영길", part: "Front", image: "영길.jpg"),
        People.init(name: "박진홍", part: "Backend", image: "진홍.jpg"),
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
    }
    
    func bind() {
        
        var userInfo = People(name: <#String#>, part: <#String#>, image: <#String#>)
        
        Observable.from(peopleArr)
            .subscribe(onNext: { data in (userInfo.name = data.name); ( userInfo.part = data.part); (userInfo.image = data.image)})
            .disposed(by: disposeBag)
        
        var img = UIImage(named: userInfo.image)
        profilePhoto.rx.image.onNext(img)
        devName.rx.text.onNext(userInfo.name)
        devPart.rx.text.onNext(userInfo.part)
        
        
    }
    
    
}



struct People {
    var name: String
    var part: String
    var image: String
    
}

