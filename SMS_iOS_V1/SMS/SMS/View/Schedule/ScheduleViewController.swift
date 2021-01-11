import UIKit

import RxSwift
import RxCocoa
import JTAppleCalendar

class ScheduleViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()
    weak var coordinator: ScheduleCoordinator?
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var calendar: JTACMonthView!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetting()
        self.calendarSetting()
        bindAction()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

//MARK- extension
extension ScheduleViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let text = globalDateFormatter(.month, date)
        monthLbl.text = text
        handleCellHidden(cell: cell as! DayCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        cell?.translatesAutoresizingMaskIntoConstraints = false
        if cellState.isSelected {
            let cellLayer = cell?.selectedBackgroundView?.layer
            cellLayer?.shadowOffset = CGSize(width: 0, height: 2)
            cellLayer?.shadowColor = UIColor.lightGray.cgColor
            cellLayer?.opacity = 0.7
            cellLayer?.shadowRadius = 2
            cellLayer?.cornerRadius = 10
        } else {
            let cellLayer = cell?.selectedBackgroundView?.layer
            cellLayer?.shadowOffset = CGSize(width: 0, height: 2)
            cellLayer?.shadowColor = UIColor.lightGray.cgColor
            cellLayer?.opacity = 0.7
            cellLayer?.shadowRadius = 2
            cellLayer?.cornerRadius = 10
        }
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
    
    func handleCellHidden(cell: DayCell, cellState: CellState) {
        cell.dateLbl.text = cellState.text
        
        calendar.visibleDates { visibledate in
            let text = globalDateFormatter(.month, visibledate.monthDates.first!.date)
            self.monthLbl.text = text
        }
        
        if cellState.dateBelongsTo != .thisMonth {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
    }
    
}

extension ScheduleViewController {
    private func calendarSetting() {
        calendar.scrollingMode = .stopAtEachCalendarFrame
        calendar.scrollDirection = .horizontal
        calendar.scrollToDate(Date())
        calendar.minimumInteritemSpacing =  0
        calendar.minimumLineSpacing = 0
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
    
    private func changeHidden() {
        var bool = false
        tableView.isHidden = bool
        timeScheduleView.isHidden = !bool
        calendarView.isHidden = bool
        headerView.isHidden = bool
        bool.toggle()
    }
}

extension ScheduleViewController {
    private func bindAction() {
        previousBtn.rx.tap
            .bind { _ in
                self.calendar.scrollToSegment(.previous)
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind { _ in
                self.calendar.scrollToSegment(.next)
            }.disposed(by: disposeBag)
        
        changeViewBtn.rx.tap
            .bind { _ in
                self.changeHidden()
            }.disposed(by: disposeBag)
    }
}
