import UIKit

import FSCalendar
import JTAppleCalendar

class DayCell: JTACDayCell {
    
    @IBOutlet weak var event3View: UIView!
    @IBOutlet weak var event2View: UIView!
    @IBOutlet weak var event1View: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        autoLayout()
    }
     
    func autoLayout() {
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        event1View.translatesAutoresizingMaskIntoConstraints = false
        event2View.translatesAutoresizingMaskIntoConstraints = false
        event3View.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            dateLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            event1View.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            event1View.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            event1View.topAnchor.constraint(equalTo: dateLbl.bottomAnchor, constant: 3.5),
            event2View.leadingAnchor.constraint(equalTo: event1View.leadingAnchor),
            event2View.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            event2View.topAnchor.constraint(equalTo: event1View.bottomAnchor, constant: 3),
            event3View.topAnchor.constraint(equalTo: event2View.bottomAnchor, constant: 3),
            event3View.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            event3View.leadingAnchor.constraint(equalTo: event2View.leadingAnchor)
        ])
    }
}
