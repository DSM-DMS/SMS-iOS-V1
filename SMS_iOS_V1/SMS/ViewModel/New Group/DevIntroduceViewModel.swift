//
//  DevIntroduceViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/12.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxViewController
import RxSwift
import RxCocoa

class DevIntroduceViewModel {
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
    
    let output: Output
    
    struct Output {
        let developSignal: Signal<[People]>
    }
    
    init() {
        output = Output(developSignal: Signal.of(peopleArr) )
    }
}

struct People {
    var name: String
    var part: String
    var image: String
}

