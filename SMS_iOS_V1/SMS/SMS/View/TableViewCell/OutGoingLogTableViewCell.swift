//
//  OutGoingLogTableViewCell.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class OutGoingLogTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    @IBOutlet var lateView: UIView!
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var outGoingStateLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var emergencyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setting()
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setting() {
        self.lateView.layer.cornerRadius = 10
        self.lateView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        reasonLbl.layer.zPosition = 1
        
        self.addShadow(maskValue: true,
                       offset: CGSize(width: 0, height: 2),
                       shadowRadius: 2,
                       opacity: 0.7,
                       cornerRadius: 10)
    }
}
