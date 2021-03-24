//
//  NoticeTableViewCell.swift
//  SMS
//
//  Created by DohyunKim on 2021/02/03.
//  Copyright © 2021 DohyunKim. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    var uuid: String?

    @IBOutlet weak var cellNumber: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var cellViews: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
