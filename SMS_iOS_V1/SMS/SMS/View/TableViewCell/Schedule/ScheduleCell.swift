import UIKit

class ScheduleCell: UITableViewCell {
    static let xibName = "ScheduleCell"

    @IBOutlet var scheduleColorView: UIView!
    @IBOutlet var scheduleInfoLbl: UILabel!
    @IBOutlet var scheduleDateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
