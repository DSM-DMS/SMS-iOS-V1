import UIKit
import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController {
    private var firstDate: Date?
    var holidayArr = ["2020-09-10","2020-09-24"]
    var arr = ["2020-09-10","2020-09-21","2020-09-22"]
    var redArr = ["2020-09-20"]
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var headerView: FSCalendarHeaderView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    override func viewDidLoad() {
        self.changeViewBtn.addShadow(offset: CGSize(width: 0, height: 2.5),
                                     color: .gray,
                                     radius: CGFloat(2),
                                     opacity: 0.5)
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
    }
    
    @IBAction func changeScheduleAndAcademicSchedule (_ sender: UIButton) {
        if sender.isSelected {
            self.changeHidden(value: true)
        } else {
            self.changeHidden(value: false)
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func previousBtn (_ sender: UIButton) {
        let previous = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)!
        self.calendarView.setCurrentPage(previous, animated: true)
    }
    
    @IBAction func nextBtn (_ sender: UIButton) {
        let next = Calendar.current.date(byAdding: .month, value: +1, to: calendarView.currentPage)!
        self.calendarView.setCurrentPage(next, animated: true)
    }
}

//MARK - extension

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar (_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let a = dateFormatter2.string(from: date)
        let previousDate = dateFormatter2.string(from: Date(timeInterval: -86400, since: date))
        let nextDate = dateFormatter2.string(from: Date(timeInterval: +86400, since: date))
        
        if holidayArr.contains(a) && arr.contains(a) {
            return 2
        }
        if holidayArr.contains(a) {
            if holidayArr.contains(previousDate) && holidayArr.contains(nextDate) {
                return 0
            } else if holidayArr.contains(nextDate) {
                return 0
            } else {
                calendarView.appearance.eventOffset = CGPoint(x: 13, y: -35)
                return 1
            }
        }
        
        if arr.contains(a) {
            if arr.contains(previousDate) && arr.contains(nextDate) {
                return 0
            } else if arr.contains(nextDate) {
                return 0
            } else {
                return 1
            }
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        cell.eventIndicator.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        self.configure(cell: cell, for: date, at: position)
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let calCell = (cell as! CalendarCollectionViewCell)
        let combineArray = arr + holidayArr
        let strDate = dateFormatter2.string(from: date)
        let previousDate = dateFormatter2.string(from: Date(timeInterval: -86400, since: date))
        let nextDate = dateFormatter2.string(from: Date(timeInterval: +86400, since: date))
        let date = dateFormatter2.string(from: date)
        if position == .current {
            var selectionType = SelectionType.none
            
            if combineArray.contains(strDate){
                if combineArray.contains(strDate){
                    if (combineArray.contains(previousDate) && combineArray.contains(nextDate)) {
                        selectionType = .middle
                    } else if combineArray.contains(previousDate) && combineArray.contains(date) {
                        selectionType = .rightBorder
                    } else if combineArray.contains(nextDate) {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            if selectionType == .none {
                calCell.eventLayer!.isHidden = true
                return
            }
            calCell.eventLayer!.isHidden = false
            calCell.selectionType = selectionType
        } else {
            calCell.eventLayer!.isHidden = true
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        if firstDate == nil {
            firstDate = date
        } else {
            calendar.deselect(firstDate!)
            firstDate = nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
        calendar.deselect(date)
        firstDate = nil
    }
    
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let strDate = dateFormatter2.string(from: date)
        if arr.contains(strDate) {
            return [.green, .purple]
        }
        if holidayArr.contains(strDate) {
            return [.purple]
        }
        return [.clear]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let strDate = dateFormatter2.string(from: date)
        if arr.contains(strDate) {
            return [.green, .purple]
        }
        if holidayArr.contains(strDate) {
            return [.purple]
        }
        return [.clear]
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.yearLabel.text = dateFormatter.string(from: calendar.currentPage)
    }
    
    func calendarSetting() {
        let ca = calendarView.appearance
        ca.headerMinimumDissolvedAlpha = 0.0;
        ca.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.delegate = self
        calendarView.dataSource = self
        timeScheduleView.isHidden = true
        self.yearLabel.text = dateFormatter.string(from: calendarView.currentPage)
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ScheduleViewController {
    func tableViewSetting() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 3, opacity: 0.5)
        tableView.layer.cornerRadius = 17
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func changeHidden(value: Bool) {
        yearLabel.isHidden = !value
        leftBtn.isHidden = !value
        rightBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
    
//    func setTableViewHeight(count: Int = 1) -> CGFloat {
//        return CGFloat(Double(count) * 44.5)
//    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if redArr.count == 2 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            bottomLayout.isActive = false
        } else if indexPath.row == holidayArr.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            bottomLayout.isActive = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nibName = UINib(nibName: "ScheduleCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "scheduleCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.scheduleDateLbl.text = "7/10"
        return cell
    }
}
