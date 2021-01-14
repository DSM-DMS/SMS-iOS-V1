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
    
    struct Input {
        let userinfo: Driver<String>
    }
    
    struct Output {
        let userName: Driver<String>
        let userNum: Driver<String>
        let userStatus: Driver<String>
        let userImg: Driver<UIImage>
        
    }
    
    func transform(_ input: Input) -> Output {
        
    }
    
}
