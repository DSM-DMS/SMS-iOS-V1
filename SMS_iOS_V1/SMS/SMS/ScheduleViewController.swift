import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController {
    
    var leftBtn: UIButton!
    var rightBtn: UIButton!
    var holidayArr = [String]()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    @IBOutlet weak var timeScheduleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var changeViewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        timeScheduleView.isHidden = true
        leftBtn = UIButton(frame: CGRect(x: 80, y: 75, width: 30, height: 30))
        leftBtn.setBackgroundImage(UIImage(named: "leftBtn"), for: .normal)
        leftBtn.addTarget(self, action: #selector(previousBtn(_:)), for: .touchUpInside)
        rightBtn = UIButton(frame: CGRect(x: 280, y: 75, width: 30, height: 30))
        rightBtn.setBackgroundImage(UIImage(named: "rightBtn"), for: .normal)
        rightBtn.addTarget(self, action: #selector(nextBtn(_:)), for: .touchUpInside)
        self.view.addSubview(leftBtn)
        self.view.addSubview(rightBtn)
        self.tableView.frame.size.height = setTableViewHeight(count: 2)
        leftBtn.layer.zPosition = 0.1
        rightBtn.layer.zPosition = 0.1
    }
    
    @IBAction func changeScheduleAndAcademicSchedule(_ sender: UIButton) {
        if sender.isSelected {
            self.changeHidden(value: true)
        } else {
            self.changeHidden(value: false)
        }
        sender.isSelected = !sender.isSelected
    }
    calendarevent
}

extension ScheduleViewController {
    @objc func previousBtn(_ sender: UIButton) {
        let previous = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        self.calendarView.setCurrentPage(previous, animated: true)
    }
    
    @objc func nextBtn(_ sender: UIButton) {
        let next = Calendar.current.date(byAdding: .month, value: +1, to: calendarView.currentPage)!
        self.calendarView.setCurrentPage(next, animated: true)
    }
    
    func calendarSetting() {
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.eventOffset = CGPoint(x: 15, y: -35)
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        ca.headerDateFormat = "yyyy년 M월"
        ca.headerTitleColor = .black
        ca.weekdayTextColor = .black
        calendarView.today = nil
        calendarView.placeholderType = .none
        ca.headerTitleFont = UIFont(name: "Helvetica-Bold", size: 18)
        print(calendarView.preferredHeaderHeight)
    }
    
    func tableViewSetting() {
        self.tableView.tableFooterView = UIView.init(frame: .infinite)
        self.tableView.backgroundColor = UIColor(displayP3Red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 20
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setTableViewHeight(count: Int = 1) -> CGFloat {
        return CGFloat(Double(count) * 44.5)
    }
    
    func changeHidden(value: Bool) {
        leftBtn.isHidden = !value
        rightBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}

// 이벤트 어떻게 처리할지
// 날짜 한번 더 누르면 제거하기
// 헤더뷰와 위크데이뷰 늘릴 방법 찾기
// 연속으로 이어진 날짜 처리
