//
//  MypageViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/15.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MypageViewController: UIViewController, Storyboarded {
    weak var coordinator: MyPageCoordinator?
    
    let viewModel = MypageViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var pwChangeButton: CustomShadowButton!
    @IBOutlet weak var logOutButton: CustomShadowButton!
    @IBOutlet weak var introduceDevButton: CustomShadowButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        
        viewModel.mypageData.subscribe { [self] data in
            let model = try? MypageModel(from: data as! Decoder)
            nameLabel.text = model!.name
            numberLabel.text = String(model!.student_number)
            statusLabel.text = String(model!.status)
        }
        .disposed(by: disposeBag)
    }
    
}
