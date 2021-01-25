import UIKit

import RxSwift
import RxCocoa

class TimeScheduleXib: UIView {
    var cnt = 0
    let disposeBag = DisposeBag()
    lazy var mondayCompo = Calendar.current.dateComponents([.year, .month, .day], from: getMonday(myDate: Date()))
    
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
        getTimeTable()
    }
    
    func getTimeTable() {
        Observable
            .range(start: mondayCompo.day!, count: 5)
            .flatMap { day -> Observable<TimeTableModel> in
                return SMSAPIClient.shared.networking(from: .timetables(self.mondayCompo.year!, self.mondayCompo.month!, day))
            }.bind { model in
                let dayArr = [self.mondayLabels, self.tuesdayLabels, self.wedsLabels, self.thirsdayLabels, self.fridayLabels]
                var arr: [String?]
               
                if self.cnt == 4 {
                    arr = [model.time1, model.time2, model.time3, model.time4, model.time5, model.time6]
                } else {
                    arr = [model.time1, model.time2, model.time3, model.time4, model.time5, model.time6, model.time7]
                }
                
                for i in 0..<arr.count {
                    dayArr[self.cnt]![i].text = arr[i]
                }
                self.cnt += 1
            }.disposed(by: disposeBag)
    }
}
