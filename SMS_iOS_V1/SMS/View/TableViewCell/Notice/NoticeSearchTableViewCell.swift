//
//  NoticeSearchTableViewCell.swift
//  SMS
//
//  Created by DohyunKim on 2021/03/15.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

class NoticeSearchTableViewCell: UITableViewCell {
    
    var uuid: String?

    @IBOutlet weak var searchCellNum: UILabel!
    @IBOutlet weak var searchCellTitle: UILabel!
    @IBOutlet weak var searchCellDate: UILabel!
    @IBOutlet weak var searchCellViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
