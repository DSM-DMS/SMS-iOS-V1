import UIKit

class TimeScheduleXib: UIView {
    private let xibName = "TimecScheduleXib"
    
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
    
    //    func commonInit() {
    //        guard let xibName = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last else { return }
    //        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
    //        view.frame = self.bounds
    //        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //        self.addSubview(view)
    //    }
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
