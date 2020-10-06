//
//  LoginViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/05.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class LoginViewModel {
    
    let view = LoginViewController()
    let url = URL(string: "")
    
    func request() {
        let id = view.IDTextField.text!
        let pw = view.PWTextField.text!
        
        let param = ["id":id, "pw":pw]
        
        let header = ["application/json":"content-type"]
        
        Alamofire.request(url!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON {
            (response) in
            switch response.result {
            case .success(_) :
                if let json = response.value {
                   json as! [String:AnyObject]
                }
            }
        }
        

    }
    
}
