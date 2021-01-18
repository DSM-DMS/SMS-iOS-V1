//
//  MypageViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/01/06.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class MypageViewModel {
    
    let disposeBag = DisposeBag()
    
    let mypageData : Observable<MypageModel> = SMSAPIClient.shared.networking(from: SMSAPI.myInfo) 
    
    
}




