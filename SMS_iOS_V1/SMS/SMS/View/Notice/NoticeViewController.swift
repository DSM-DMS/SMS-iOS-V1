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
            let cellElements = [idx!, title!, date!, views!] as [Any]
            if data.element?.status == 200 || data.element?.code == 200 {
                Observable.from(optional: cellElements)
                    .bind(to: self.noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName)) {_, cellElements, cell in
                        if let celltoUse = cell as? NoticeTableViewCell {
                            celltoUse.cellNumber.text = cellElements[0]
                            celltoUse.cellTitle.text = cellElements[1]
                            celltoUse.cellDate.text = cellElements[2]
                            celltoUse.cellViews.text = cellElements[3]
                        }
                        
                    }
                
//                noticeTableView.rx.items(cellIdentifier: NoticeTableViewCell.NibName)
                
                
            }
            
        }.disposed(by: disposeBag)
        
    }
    
}
