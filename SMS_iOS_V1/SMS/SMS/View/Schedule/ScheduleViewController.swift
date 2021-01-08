import UIKit

import FSCalendar
import RxSwift
import RxCocoa
import JTAppleCalendar

class ScheduleViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: ScheduleCoordinator?

    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetting()
        self.calendarSetting()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

//MARK- extension
extension ScheduleViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCellTextColor(cell: cell as! DayCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        calendar.scrollToSegment(.next)
        print(date)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DayCell.NibName, for: indexPath) as! DayCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = globalDateFormatter(.untilDay, "2020-01-01")
        let endDate = globalDateFormatter(.untilDay, "2030-01-01")
        
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
    
    func handleCellTextColor(cell: DayCell, cellState: CellState) {
        cell.dateLbl.text = cellState.text
        if cellState.dateBelongsTo != .thisMonth {
//            cell.isHidden = true
        }
    }
}
 
extension ScheduleViewController {
    private func calendarSetting() {
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        calendarView.scrollToDate(Date())
        calendarView.minimumInteritemSpacing =  0
        calendarView.minimumLineSpacing = 0
    }
    
    private func tableViewSetting() {
        timeScheduleView.isHidden = true
        tableView.register(ScheduleCell.self)
        tableView.separatorStyle = .none
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.addShadow(offset: CGSize(width: 0, height: 3),
                            color: .black,
                            shadowRadius: 3,
                            opacity: 0.5,
                            cornerRadius: 17)
    }
    
    private func changeHidden(value: Bool) {
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}

