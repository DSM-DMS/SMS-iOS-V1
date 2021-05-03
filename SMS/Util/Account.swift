//
//  Account.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/23.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

class Account {
    static let shared = Account()
    
    func removeUD() {
        UD.removeObject(forKey: "token")
        UD.removeObject(forKey: "uuid")
    }
    
    func setUD(_ token: String?, _ uuid: String?) {
        UD.set(token, forKey: "token")
        UD.set(uuid, forKey: "uuid")
    }
}
