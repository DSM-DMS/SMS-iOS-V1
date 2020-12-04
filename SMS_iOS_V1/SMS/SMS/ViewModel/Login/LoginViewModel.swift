//
//  LoginViewModel.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire
import RxAlamofire

class LoginViewModel {
    
    let view = LoginViewController()
    
    let param = ["id" : " ", "pw" : " "]
    let header = ["application/json" : "content-type"]
    let url = URL(string: " ")!
    
    func request() {
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
            case .success :
                print(response)
                break
                
            case .failure(let error) :
                print(error.localizedDescription)
                
                
            }
        }
        
        
        
    }
    
//    func presentingViewController() {
//        let rootViewController = StoryBoard.Login.viewController
//        let presentViewController = StoryBoard.Schedule.viewController
//        presentViewController.modalPresentationStyle = .fullScreen
//        rootViewController.present(presentViewController, animated: true, completion: nil)
//    }
}
