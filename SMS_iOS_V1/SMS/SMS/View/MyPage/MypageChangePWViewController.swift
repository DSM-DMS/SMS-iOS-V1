//
//  MypageChangePWViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import KeychainSwift

class MypageChangePWViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageChangePWViewModel()
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var applyButton: CustomShadowButton!
    @IBOutlet weak var currentPWTextField: UITextField!
    @IBOutlet weak var newPWTextField: UITextField!
    @IBOutlet weak var confirmPWTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}
extension MypageChangePWViewController {
    func bind() {
        let input = MypageChangePWViewModel.Input.init(currentPWTextFieldDriver: currentPWTextField.rx.text.orEmpty.asDriver(), newPWTextFieldDriver: newPWTextField.rx.text.orEmpty.asDriver(), confirmPWTextFieldDriver: confirmPWTextField.rx.text.orEmpty.asDriver(), changeButtonDrver: applyButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input)
        
        output.result.subscribe { model in
            if model.status == 200 || model.code == 200 {
                print("패스워드 변경 완료")
                let keychain = KeychainSwift()
                keychain.delete("ID")
                keychain.delete("PW")
                NSLog("Keychain Deleted")
            }
        } onError: {_ in
            fatalError("비밀번호 변경 실패")
        }.disposed(by: disposeBag)
        
    }
    
}
