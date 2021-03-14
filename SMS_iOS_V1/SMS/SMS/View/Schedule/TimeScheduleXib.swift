import UIKit

import RxSwift
import RxCocoa

class TimeScheduleXib: UIView {
    
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
    }
    
    func getTimeTable() {
        let timeTable: Observable<TimeTableModel> = SMSAPIClient.shared.networking(from: .timetables(self.mondayCompo.year!, self.mondayCompo.month!, self.mondayCompo.day!))
        
        timeTable.subscribe { model in
            if model.status == 200 {
                
                var arr: [[String]] = []
                
                for i in 0...4 {
                    arr.append([model.time_tables![i].time1, model.time_tables![i].time2, model.time_tables![i].time3, model.time_tables![i].time4, model.time_tables![i].time5, model.time_tables![i].time6, model.time_tables![i].time7])
                }
                
                let dayArr = [self.mondayLabels, self.tuesdayLabels, self.wedsLabels, self.thirsdayLabels, self.fridayLabels]

                for i in 0...4 {
                    for j in 0...6 {
                        dayArr[i]![j].text = arr[i][j] == "" ? "-" : arr[i][j]
                    }
                }
            }
        } onError: {  error in
            if error as? StatusCode == StatusCode.internalServerError {
                self.makeToast("인터넷 연결 실패")
            }
        }.disposed(by: disposeBag)
    }
}
