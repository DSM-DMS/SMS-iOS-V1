import UIKit

import RxSwift
import RxCocoa

class TimeScheduleXib: UIView {
    
    let disposeBag = DisposeBag()
    lazy var mondayCompo = Calendar.current.dateComponents([.year, .month, .day], from: getMonday(myDate: Date()))
    
    @IBOutlet weak var monLbl: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var thiLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
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
        setting()
    }
    
    func setting() {
        
        
        let index = Calendar.current.component(.weekday, from: Date()) - 2
        let arr: [UILabel] = [monLbl, tueLabel,wedLabel,thiLabel,friLabel]
        if index >= 0 && index <= 4 {
            arr[index].backgroundColor = .customPurple
            arr[index].textColor = .white
            arr[index].layer.cornerRadius = 10
            arr[index].layer.masksToBounds = true
        }
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
                self.makeToast("인터넷 연결 실패", point: CGPoint(x: screen.width / 2, y: screen.height - 120), title: nil, image: nil, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
}
