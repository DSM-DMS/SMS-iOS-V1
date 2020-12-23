import UIKit

import RxSwift
import RxCocoa

class TimeScheduleXib: UIView {
    let disposeBag = DisposeBag()
    let calendar = Calendar.current
    lazy var mondayCompo = calendar.dateComponents([.year, .month, .day], from: getMonday(myDate: Date()))
    
    @IBOutlet weak var dateView: CustomShadowView!
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
        let view = Bundle.main.loadNibNamed(TimeScheduleXib.NibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        let monday: Observable<TimeTableModel> = SMSAPIClient.shared.networking(from: .timetables(mondayCompo.year!, mondayCompo.month!, mondayCompo.day!))
        
        monday.bind{ model in
            let arr = [model.time1, model.time2, model.time3, model.time4, model.time5, model.time6, model.time7]
            for i in 0...6 {
                self.mondayLabels[i].text = arr[i]
            }
        }.disposed(by: disposeBag)
        
        
        
    }
}
