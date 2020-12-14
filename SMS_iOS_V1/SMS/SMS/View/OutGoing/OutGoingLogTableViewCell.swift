//
//  OutGoingLogTableViewCell.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingLogTableViewCell: UITableViewCell {
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var outGoingStateLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var detailOutGoing: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addShadow(offset: CGSize(width: 0, height: 2),
                       color: .lightGray,
                       shadowRadius: 2,
                       opacity: 0.7,
                       cornerRadius: 10)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
