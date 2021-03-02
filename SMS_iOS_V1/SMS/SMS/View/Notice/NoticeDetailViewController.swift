//
//  NoticeDetailViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/10/23.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class NoticeDetailViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    let viewModel = NoticeDetailViewModel()
    weak var coordinator: NoticeCoordinator?
    
    
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var notice: UITextView!
    @IBOutlet weak var previousNotice: UIButton!
    @IBOutlet weak var nextNotice: UIButton!
    
    //previous noticebtn
    //nextnoticebtn
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
}

extension NoticeDetailViewController {
    func bind() {
        viewModel.NoticeDetailData.subscribe { [self] data in
            let model = try? NoticeDetailModel(from: data as! Decoder)
            if (Int(model!.status) == 200) {
                noticeTitle.text = model?.title
                date.text = String(model!.date)
//                views.text = String(model!.views) API에 조회수 추가되면 NoticeDetailModel에 views 추가하고 주석 풀 것.
                notice.text = model?.content
                previousNotice.setTitle(model?.previous_title, for: .normal)
                nextNotice.setTitle(model?.next_title, for: .normal)
            }
            else {
                print("404 error")
                fatalError()
            }
            
        }.disposed(by: disposeBag)
        
    }
    
}
