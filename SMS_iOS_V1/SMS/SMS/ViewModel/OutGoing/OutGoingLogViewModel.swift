//
//  OutGoingLogViewModel.swift
//  SMS
//
//  Created by 이현욱 on 2021/04/22.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class OutGoingLogViewModel {
    let count: Int
    
    let response: Observable<OutGoingLogModel>
    
    let network: Networking
    
    init(network: Networking, count: Int) {
        self.network = network
        self.count = count
        
        self.response = network.networking(from: .lookUpAllOuting(0, count))
    }
}
