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
    
    func setting(_ notice: Announcements) {
        self.selectionStyle = .none
        self.uuid = notice.announcement_uuid
        self.searchCellDate.text = globalDateFormatter(.untilDay, unix(with: notice.date / 1000))
        self.searchCellNum.text = "\(notice.number)"
        self.searchCellTitle.text = notice.title
        self.searchCellViews.text = "\(notice.views)"
    }
}
