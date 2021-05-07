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
import Kingfisher
import RxViewController

class MypageViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = MyPageViewModel(networking: SMSAPIClient.shared)
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var logOutView: LogOutView!
    @IBOutlet weak var pwChangeButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var introduceDevButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setting()
    }
}

extension MypageViewController {
    func bind() {
        self.rx.viewDidLoad.map { _ in }
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        backgroundBtn.rx.tap
            .bind { [weak self] _ in
                self?.isViewHidden(true)
            }.disposed(by: disposeBag)
        
        pwChangeButton.rx.tap
            .bind { _ in
                self.coordinator?.changePW()
            }.disposed(by: disposeBag)
        
        introduceDevButton.rx.tap
            .bind { _ in
                self.coordinator?.introduce()
            }.disposed(by: disposeBag)
        
        logOutButton.rx.tap
            .bind { [weak self] _ in
                self?.isViewHidden(false)
                self?.logOutView.sign = { b in
                    self?.isViewHidden(true)
                    if b {
                        Account.shared.removeUD()
                        self?.coordinator?.main()
                    }
                }
            }.disposed(by: disposeBag)
        
        viewModel.output.myInfo.subscribe(onNext: { [weak self] model in
            if model.status == 200 {
                let zero = model.student_number! > 10 ? "" : "0"
                self?.nameLabel.text = model.name
                self?.numberLabel.text = "\(model.grade!)\(model.group!)" + zero + "\(model.student_number!)"
                let imageURL = URL(string: imageBaseURL + "\(model.profile_uri!)")
                self?.imageVIew.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
                self?.imageVIew.layer.cornerRadius = (self?.imageVIew.bounds.height)! / 2
            } else if model.status == 401 {
                self?.coordinator?.main()
            }
        }, onError: { [weak self] error in
            if error as? StatusCode == StatusCode.internalServerError {
                self?.view.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func setting() {
        logOutView.addShadow(maskValue: true,
                             offset: CGSize(width: 0, height: 3),
                             shadowRadius: 6,
                             opacity: 1,
                             cornerRadius: 8)
    }
    
    func isViewHidden(_ value: Bool) {
        logOutView.isHidden = value
        backgroundBtn.isHidden = value
    }
}
