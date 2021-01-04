////
////  OutGoingLocationXib.swift
////  SMS
////
////  Created by 이현욱 on 2020/12/30.
////  Copyright © 2020 DohyunKim. All rights reserved.
////
//
//import UIKit
//
//import RxSwift
//import RxCocoa
//
//class OutGoingLocationAlertView: UIView {
//    let disposeBag = DisposeBag()
////    var sign: ((String) -> ())?
//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var locationSearchBar: UISearchBar!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.commonInit()
//    }
//
//    private func commonInit(){
//        let view = Bundle.main.loadNibNamed(OutGoingLocationAlertView.NibName, owner: self, options: nil)?.first as! UIView
//        view.frame = self.bounds
//        self.addSubview(view)
////        tableView.rowHeight = 70
//    }
//}
//
//extension OutGoingLocationAlertView {
//    func bind() {
//        locationSearchBar.rx.searchButtonClicked
//            .map { self.locationSearchBar.text! }
//            .filter { txt in
//                txt != "" || !txt.isEmpty
//            }
//            .distinctUntilChanged()
//            .flatMap { txt -> Observable<OutLocationModel> in
//                SMSAPIClient.shared.networking(from: .location(txt))
//            }.map { model in
//                model.item!
//            }.bind(to: tableView.rx.items(cellIdentifier: LocationTableViewCell.NibName, cellType: LocationTableViewCell.self)) { _, address, cell in
//                cell.addressLbl.text = address.address
//                cell.roadAddressLbl.text = address.roadAddress
//            }.disposed(by: disposeBag)
//    }
//}
//
//  view.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/30.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingLocationAlertView: UIView {
    let disposeBag = DisposeBag()
    var sign: ((Bool) -> ())? = nil
    
//    @IBOutlet weak var cancelBtn: UIButton!
//    @IBOutlet weak var applicationBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
//        bindAction()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(OutGoingLocationAlertView.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
//    @IBAction func cancelTapped(_ sender: UIButton) {
//        sign?(false)
//    }
//    @IBAction func OKTapped(_ sender: UIButton) {
//        sign?(true)
//    }
}

//extension OutGoingAlertXib {
//    func bindAction() {
//        cancelBtn.rx.tap
//            .bind { self.sign?(false) }
//            .disposed(by: disposeBag)
//        
//        applicationBtn.rx.tap
//            .bind { _ in
//                self.sign?(true)
//            }
//            .disposed(by: disposeBag)
//    }
//}
