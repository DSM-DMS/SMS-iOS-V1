//
//  MypageIntroduceDevViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class MypageIntroduceDevViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = DevIntroduceViewModel()
    weak var coordinator: MyPageCoordinator?
    
    @IBOutlet weak var devCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setting()
    }
}

extension MypageIntroduceDevViewController: UIScrollViewDelegate {
    func bind() {
        backButton.rx.tap
            .bind { _ in
                self.coordinator?.pop()
            }.disposed(by: disposeBag)
        
        viewModel.output.developSignal.asObservable()
            .bind(to: devCollectionView.rx.items(cellIdentifier: DevCollectionViewCell.NibName, cellType: DevCollectionViewCell.self)) { _, people, cell in
                cell.setting(people)
            }.disposed(by: disposeBag)
    }
    
    func setting() {
        devCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let flowLayout = UICollectionViewFlowLayout()
        let height = UIScreen.main.bounds.height / 3.76
        let width = UIScreen.main.bounds.width / 2.9
        flowLayout.itemSize = CGSize(width: width, height: height)
        devCollectionView.setCollectionViewLayout(flowLayout, animated: true)
    }
}
