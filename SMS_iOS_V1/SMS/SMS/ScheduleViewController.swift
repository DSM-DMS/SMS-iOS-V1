import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    private var firstDate: Date?
    var holidayArr = [String]()
    var diffDate = String()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimecScheduleXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        timeScheduleView.isHidden = true
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func changeScheduleAndAcademicSchedule(_ sender: UIButton) {
        if sender.isSelected {
            self.changeHidden(value: true)
        } else {
            self.changeHidden(value: false)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func previousBtn(_ sender: UIButton) {
        let previous = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: previous)
        self.calendarView.setCurrentPage(previous, animated: true)
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        let next = Calendar.current.date(byAdding: .month, value: +1, to: calendarView.currentPage)!
        yearLabel.text = dateFormatter.string(from: next)
        self.calendarView.setCurrentPage(next, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter2.string(from: date))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        print("did deselect date \(self.dateFormatter2.string(from: date))")
        self.configureVisibleCells()
    }
    
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let calCell = (cell as! CalendarCollectionViewCell)
        // Custom today circle
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendarView.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendarView.selectedDates.contains(date) {
                    if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendarView.selectedDates.contains(previousDate) && calendarView.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendarView.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                calCell.selectionLayer.isHidden = true
                return
            }
            calCell.selectionLayer.isHidden = false
            calCell.selectionType = selectionType
            
        } else {
            calCell.circleImageView.isHidden = true
            calCell.selectionLayer.isHidden = true
        }
    }
}

extension ScheduleViewController {
    func calendarSetting() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.eventOffset = CGPoint(x: 15, y: -35)
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        ca.weekdayTextColor = .black
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.headerHeight = 0
        calendarView.allowsMultipleSelection = true
        calendarView.configureAppearance()
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
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
// 연속으로 이어진 날짜 처리 -> 서버에서 이벤트받은 날로 처리해주고 연속하는 것만 해도록 하자
// 스와이프해도 날짜 바뀌게
