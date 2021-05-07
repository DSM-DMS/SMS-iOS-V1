//
//  OutGoingCompletedViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingCompletedViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    var text: Int!
    weak var coordinator: OutGoingCoordinator?
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
        setting()
    }
}



extension OutGoingCompletedViewController {
    private func bindAction() {
        checkButton.rx.tap
            .bind { _ in
                self.coordinator?.popAll()
            }.disposed(by: disposeBag)
    }
    
    func setting() {
        var txt = ""
        switch text {
        case -1:
            txt = "연결된 학부모 계정이 존재하지 않습니다. 선생님께 바로 찾아가 승인을 받아주세요."
        case -2:
            txt = "학부모가 문자 사용을 동의하지 않았습니다. 선생님께 바로 찾아가 승인을 받아주세요."
        default:
            txt = "승인을 받은 후 모바일을 통해 외출을 시작해주세요."
        }
        if let attributedString = createAttributedString(stringArray: txt.components(separatedBy: " "),
                                                         attributedPart: 3,
                                                         attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor.customPurple,
                                                            NSAttributedString.Key.font: UIFont.init(name: "Noto Sans CJK KR Medium",
                                                                                                     size: 23) as Any
                                                         ]
        ) {
            textLbl.attributedText = attributedString
        }
        
        self.checkButton.addShadow(maskValue: true,
                                   offset: CGSize(width: 0, height: 2),
                                   shadowRadius: 2,
                                   opacity: 0.7,
                                   cornerRadius: 10)
    }
    
    func createAttributedString(stringArray: [String], attributedPart: Int,  attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        let finalString = NSMutableAttributedString()
        for i in 0 ..< stringArray.count {
            var attributedString = NSMutableAttributedString(string: stringArray[i] + " ", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.init(name: "Noto Sans CJK KR Medium",
                                                         size: 23) as Any
            ])
            if i == attributedPart {
                attributedString = NSMutableAttributedString(string: attributedString.string + " ", attributes: attributes)
                finalString.append(attributedString)
            } else {
                finalString.append(attributedString)
            }
        }
        return finalString
    }
}

