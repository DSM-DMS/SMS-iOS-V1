import UIKit

class TimeScheduleXib: UIView {
    private let xibName = "TimeScheduleXib"
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet var mondayLabels: [UILabel]!
    @IBOutlet var tuesdayLabels: [UILabel]!
    @IBOutlet var wedsLabels: [UILabel]!
    @IBOutlet var thirsdayLabels: [UILabel]!
    @IBOutlet var fridayLabels: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        self.dateView.addShadow(offset: CGSize(width: 0, height: 2),
                           color: .lightGray,
                           shadowRadius: 2,
                           opacity: 0.7,
                           cornerRadius: 5)
    }
}
