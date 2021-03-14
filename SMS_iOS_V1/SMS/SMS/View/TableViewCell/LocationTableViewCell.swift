//
//  LocationTableViewCell.swift
//  SMS
//
//  Created by 이현욱 on 2020/12/24.
//  Copyright © 2020 DohyunKim. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var roadAddressLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = backgroundColorForDarkMode()
        
    }
}
