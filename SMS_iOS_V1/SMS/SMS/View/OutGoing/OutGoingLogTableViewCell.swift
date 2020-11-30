//
//  OutGoingLogTableViewCell.swift
//  SMS
//
//  Created by DohyunKim on 2020/09/13.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class OutGoingLogTableViewCell: UITableViewCell {

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
