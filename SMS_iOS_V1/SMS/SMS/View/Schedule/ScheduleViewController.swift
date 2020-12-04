import UIKit

import FSCalendar
import RxSwift

class ScheduleViewController: UIViewController {
    
    private lazy var dateFormatter = globalDateFormatter(formType(rawValue: formType.day.rawValue)!)
    private var firstDate: Date?
    let count = 2
    
    @IBOutlet weak var xibViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: FSCalendarHeaderView!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    override func viewDidLoad() {
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
        /// refator
        
        let a = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: date)
        let previousDate = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: Date(timeInterval: -86400, since: date))
        let nextDate = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: Date(timeInterval: +86400, since: date))
        
        
//        if holidayArr.contains(a) && arr.contains(a) {
            return 2
//        }
//        if holidayArr.contains(a) {
//            if holidayArr.contains(previousDate) && holidayArr.contains(nextDate) {
//                return 0
//            } else if holidayArr.contains(nextDate) {
//                return 0
//            } else {
//                calendarView.appearance.eventOffset = CGPoint(x: 13, y: -35)
//                return 1
//            }
//        }
//
//        if arr.contains(a) {
//            if arr.contains(previousDate) && arr.contains(nextDate) {
//                return 0
//            } else if arr.contains(nextDate) {
//                return 0
//            } else {
//                return 1
//            }
//        }
//        return 0
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        cell.eventIndicator.transform = CGAffineTransform(scaleX: cell.frame.width / 25, y: cell.frame.width / 25)
        calendar.appearance.eventOffset = CGPoint(x: cell.frame.width / 3.5, y: -cell.frame.height + cell.frame.height / 18.5)
        self.configure(cell: cell, for: date, at: position)
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        /// refator
        
        let calCell = (cell as! CalendarCollectionViewCell)
        let combineArray = ["2020-10-10","2020-10-11","2020-10-14","2020-10-21","2020-10-22","2020-10-23"]
        let strDate = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: date)
        let previousDate = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: Date(timeInterval: -86400, since: date))
        let nextDate = globalDateFormatter(formType(rawValue: formType.day.rawValue)!).string(from: Date(timeInterval: +86400, since: date))
        if position == .current {
            var selectionType = SelectionType.none

            if combineArray.contains(strDate){
                if combineArray.contains(strDate){
                    if (combineArray.contains(previousDate) && combineArray.contains(nextDate)) {
                        selectionType = .middle
                    } else if combineArray.contains(previousDate) && combineArray.contains(strDate) {
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
        /// refator
        self.configureVisibleCells()
        if firstDate == nil {
            firstDate = date
        } else {
            calendar.deselect(firstDate!)
            firstDate = nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        /// refator
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
        /// refator
        let strDate = dateFormatter.string(from: date)
//        if arr.contains(strDate) {
            return [.green, .purple]
//        }
//        if holidayArr.contains(strDate) {
//            return [.purple]
//        }
//        return [.clear]
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        /// refator
        let strDate = dateFormatter.string(from: date)
//        if arr.contains(strDate) {
            return [.green, .purple]
//        }
//        if holidayArr.contains(strDate) {
//            return [.purple]
//        }
//        return [.clear]
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.yearLabel.text = globalDateFormatter(formType(rawValue: formType.month.rawValue)!).string(from: calendar.currentPage)
    }
    
    func calendarSetting() {
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.delegate = self
        calendarView.dataSource = self
        timeScheduleView.isHidden = true
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
        self.calendarCurrentPageDidChange(calendarView)
        self.changeViewBtn.addShadow(offset: CGSize(width: 0, height: 2.5),
                                     color: .gray,
                                     shadowRadius: 2,
                                     opacity: 0.5,
                                     cornerRadius: 25)
    }
}

extension ScheduleViewController {
    func tableViewSetting() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.addShadow(offset: CGSize(width: 0, height: 3),
                            color: .black,
                            shadowRadius: 3,
                            opacity: 0.5,
                            cornerRadius: 17)
    }
    
    func changeHidden(value: Bool) {
        yearLabel.isHidden = !value
        leftBtn.isHidden = !value
        rightBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /// fix
        return self.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// refactor
        cell.layer.masksToBounds = true
        if self.count == 2 {
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else if indexPath.row == 1 {
            cell.layer.cornerRadius = 17
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// refactor
        let nibName = UINib(nibName: "ScheduleCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "scheduleCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        cell.scheduleDateLbl.text = "7/10"
        return cell
    }
}