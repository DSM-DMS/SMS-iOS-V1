import UIKit

import FSCalendar
import RxSwift
import RxCocoa

class ScheduleViewController: UIViewController {
    // 한 이벤트에 대해 시작한 날짜와 끝난 날짜 -> 영화토이처럼 배열로 만들어
    // 날짜를 여러번 호출, 비슷비슷한 함수가 많이 사용되는데 이걸 줄일 방법을 찾아보고 싶음
    
    private var bool = false
//    let observable: BehaviorRelay<ScheduleModel> = .init(value: ScheduleModel(date: "", eventInfo: "", eventColor: .red))
    private let date: BehaviorRelay<Date> = .init(value: Date())
    private let disposeBag = DisposeBag()
    private lazy var dateFormatter = globalDateFormatter(formType(rawValue: formType.day.rawValue)!)
    private var firstDate: Date? = Date()
    
    @IBOutlet weak var xibViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var previousMonthBtn: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarSetting()
        self.tableViewSetting()
        bindAction()
        bindUI()
    }
}


//MARK- extension

extension ScheduleViewController {
    private func bindAction() {
        changeViewBtn.rx.tap
            .map { self.changeHidden(value: self.bool) }
            .map { self.bool.toggle() }
            .subscribe().disposed(by: disposeBag)
        
        Observable.merge(previousMonthBtn.rx.tap.map {
            Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
        }, nextMonthBtn.rx.tap.map {
            Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!
        }).map { self.calendarView.setCurrentPage($0, animated: true)
            self.yearLabel.text = globalDateFormatter(formType(rawValue: formType.month.rawValue)!).string(from: self.calendarView.currentPage)
        }
        .subscribe().disposed(by: disposeBag)
    }
    
    private func bindUI() {
//        observable.map { [$0] } // ScheduleModel 재대로 나오면 다시
//            .bind(to: tableView.rx.items(cellIdentifier: "ScheduleCell", cellType: ScheduleCell.self)) { idx, schedule, cell in
//                cell.scheduleDateLbl.text = schedule.date
//                cell.scheduleInfoLbl.text = schedule.eventInfo
//                cell.scheduleColorView.backgroundColor = schedule.eventColor
//            }.disposed(by: disposeBag)
    }
    
    private func tableViewSetting() {
        tableView.register(ScheduleCell.self)
        tableView.separatorStyle = .none
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.backgroundColor = .rgb(red: 247, green: 247, blue: 247, alpha: 1)
        tableView.addShadow(offset: CGSize(width: 0, height: 3),
                            color: .black,
                            shadowRadius: 3,
                            opacity: 0.5,
                            cornerRadius: 17)
        self.yearLabel.text = globalDateFormatter(formType(rawValue: formType.month.rawValue)!).string(from: calendarView.currentPage)
    }
    
    private func changeHidden(value: Bool) {
        yearLabel.isHidden = !value
        previousMonthBtn.isHidden = !value
        nextMonthBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
    
    private func calendarSetting() {
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.delegate = self
        calendarView.dataSource = self
        timeScheduleView.isHidden = true
        calendarView.register(CalendarCollectionViewCell.self, forCellReuseIdentifier: "cell")
        self.changeViewBtn.addShadow(offset: CGSize(width: 0, height: 2.5),
                                     color: .gray,
                                     shadowRadius: 2,
                                     opacity: 0.5,
                                     cornerRadius: 25)
    }
}

extension ScheduleViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    private func configureVisibleCells() {
        calendarView.visibleCells().forEach { (cell) in
            let date = calendarView.date(for: cell)
            let position = calendarView.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
//        let calCell = cell as! CalendarCollectionViewCell
//        var selectionType = SelectionType.none
//
//        if combineArray.contains(strDate){
//            if (combineArray.contains(previousDate) && combineArray.contains(nextDate)) {
//                selectionType = .middle
//            } else if combineArray.contains(previousDate) && combineArray.contains(strDate) {
//                selectionType = .rightBorder
//            } else if combineArray.contains(nextDate) {
//                selectionType = .leftBorder
//            } else {
//                selectionType = .single
//            }
//        }
//        if selectionType == .none {
//            calCell.eventLayer!.isHidden = true
//            return
//        }
//        calCell.eventLayer!.isHidden = false
//        calCell.selectionType = selectionType
    }
    
    //    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    //        if //이벤트 한개일떄
    //        return 1
    //        else // 이벤트 2개일때
    //        return 2
    //
    //        return 0
    //    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [.green, .purple]
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [.green, .purple]
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 짝수의 눌림때마다 2번눌러야 풀림 -> 해결해야함
        if firstDate == nil {
            firstDate = date
        } else {
            calendar.deselect(firstDate!)
            firstDate = nil
        }
        self.configureVisibleCells()
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
}

//func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
/// 어떻게 쓸지 고민
//    cell.layer.masksToBounds = true
//    if self.count == 2 {
//        cell.layer.cornerRadius = 17
//        cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//    } else if indexPath.row == 1 {
//        cell.layer.cornerRadius = 17
//        cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//    }
//}
