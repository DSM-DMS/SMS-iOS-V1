//
//  MypageLogoutViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/02.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MypageLogoutViewModel {
    
    func Logout() {
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
}
