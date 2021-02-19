//
//  NoticeViewController.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/16.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoticeViewController: UIViewController, Storyboarded {
    weak var coordinator: NoticeCoordinator?
    
    let viewModel = NoticeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchTextField: UIView!
    @IBOutlet weak var noticeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
    
}
extension NoticeViewController {
    
    func UIbind() {
        viewModel.noticeData.subscribe { [self] data in
            
            let idx = data.element?.number
            let title = data.element?.title
            let date = data.element?.date
            let views = data.element?.views
            let dataSetArr: [dataSet] = [dataSet.init(idx: idx!, title: title!, date: date!, views: views!)]
            if data.element?.status == 200 || data.element?.code == 200 {
                Observable.repeatElement(dataSetArr)
                    .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName)) {_, cellElements, cell in
                        if let celltoUse = cell as? NoticeTableViewCell {
                            celltoUse.cellNumber.text = String(cellElements.idx)
                            celltoUse.cellTitle.text = cellElements.title
                            celltoUse.cellDate.text = String(cellElements.date)
                            celltoUse.cellViews.text = String(cellElements.views)
                        }
                    }
            }
            
        }.disposed(by: disposeBag)
    }
}

struct dataSet {
    let idx: Int
    let title: String
    let date: Int
    let views: Int
    
}
