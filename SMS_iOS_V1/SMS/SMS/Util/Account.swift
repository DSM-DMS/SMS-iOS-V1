//
//  Account.swift
//  SMS
//
//  Created by 이현욱 on 2021/03/23.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import Foundation

class Account {
    let ud = UserDefaults.standard
    static let shared = Account()
    
    func removeUD() {
        ud.removeObject(forKey: "token")
        ud.removeObject(forKey: "uuid")
    }
    
    func removeKeyChain() {
        keyChain.delete("ID")
        keyChain.delete("PW")
    }
    
    func setKeyChain(_ ID: String, _ PW: String) {
        keyChain.set(ID, forKey: "ID")
        keyChain.set(PW, forKey: "PW")
    }
    
    func setUD(_ token: String?, _ uuid: String?) {
        ud.set(token, forKey: "token")
        ud.set(uuid, forKey: "uuid")
    }
}
