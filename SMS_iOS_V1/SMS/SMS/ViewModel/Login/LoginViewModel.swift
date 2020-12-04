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

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let idTextFieldDriver: Driver<String>
        let pwTextFieldDriver: Driver<String>
        let loginBtnDriver: Driver<Void>
        let autoLoginDriver: Driver<Void>
    }
    
    struct Output {
        let result: Single<LoginModel>
    }
    
<<<<<<< HEAD:SMS_iOS_V1/SMS/SMS/ViewModel/Login/LoginViewModel.swift
    func request() {
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON {
            response in
            switch response.result {
            case .success :
                print(response)
                break
                
            case .failure(let error) :
                print(error.localizedDescription)
                
                
=======
    func transform(_ input: Input) -> Output {
        var boolean : Bool = false
        
        input.autoLoginDriver.drive(onNext: { _ in
            if boolean {
                // ketchain 저장 
            } else {
                // delete keychain
>>>>>>> Login:SMS_iOS_V1/SMS/SMS/ViewModel/LoginViewModel.swift
            }
            boolean.toggle()
        }).disposed(by: disposeBag)

        
        
        let bool = input.loginBtnDriver.asObservable()
            .withLatestFrom(Observable.combineLatest(input.idTextFieldDriver.asObservable(),
                                                     input.pwTextFieldDriver.asObservable()))
            .map { (id, pw) -> SMSAPI in
                if id.isEmpty || pw.isEmpty {  }
                    return SMSAPI.login(id, pw)
            }.flatMap { request -> Observable<LoginModel> in
                return SMSAPIClient.shared.networking(from: request)
            }.asSingle()
        
        return Output(result: bool)

    }
    
//    func presentingViewController() {
//        let rootViewController = StoryBoard.Login.viewController
//        let presentViewController = StoryBoard.Schedule.viewController
//        presentViewController.modalPresentationStyle = .fullScreen
//        rootViewController.present(presentViewController, animated: true, completion: nil)
//    }
}
