import UIKit

import FSCalendar
import RxSwift
import RxCocoa

class ScheduleViewController: UIViewController, Storyboarded {
    
    let c = Calendar.init(identifier: .iso8601)
    let calendar = Calendar.current
    var sdasd: Observable<[[String]]>! = nil
    let date = globalDateFormatter(.untilDay, Date())
    lazy var yearDayArr = date.dropLast().components(separatedBy: "-").map { Int($0)! }
    lazy var a: Observable<ScheduleModel> = getSchedule(with: yearDayArr[0], with: yearDayArr[1])
    var value = false
    weak var coordinator: ScheduleCoordinator?
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var previousMonthBtn: UIButton!
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}
/*
 
 {
 "code": 0,
 "message": "succeed to get schedules with year and month",
 "schedules": [
 {
 "detail": "세부 내용을 입력해야만 알겠어?",
 "end_date": ,
 "schedule_uuid": "schedule-3724375272514",
 "start_date":
 },
 {
 "detail": "심장은 뜨겁게 뇌는 차갑게",
 "end_date": ,
 "schedule_uuid": "schedule-7722837206942",
 "start_date":
 },
 {
 "detail": "밥 먹자!",
 "end_date": ,
 "schedule_uuid": "schedule-7898672256913",
 "start_date":
 },
 {
 "detail": "야외 촬영이 있는 날입니다. 군복 챙겨오세요.",
 "end_date":
 [[1608080460000, 1608166860000, 1608598860000, 1608080460000, 1608253260000], [1607994060000, 1608166860000, 1607994060000, 1608598860000, 1607994060000]]
 "schedule_uuid": "schedule-9121050753075",
 "start_date":
 },
 {
 "detail": "공휴일",
 "end_date": ,
 "schedule_uuid": "schedule-9403808019852",
 "start_date":
 }
 ],
 "status": 200
 }
 */

//MARK- extension
extension ScheduleViewController {
    private func bindUI() { // 일정을 쫙받아온뒤에 받은걸 스트링으로 바꿔서 배열을 만든다
        sdasd = a.map { ($0.schedules ?? []) } // date -> String -> int 응답: unix(int) -> format 형식, unix int date or string ->
            .map { s -> [[String]] in
                var arrs: [[String]]! = nil
                var startArr: [String]! = nil
                var endArr: [String]! = nil
                for i in s.enumerated() {
                    startArr.append(UnixStampToDate(with: i.element.startTime, formatType: .month)) // 시작 날짜들의 배열
                    endArr.append(UnixStampToDate(with: i.element.endTime, formatType: .month)) // 끝 날짜들의 배열
                }
                arrs.append(startArr)
                arrs.append(endArr)
                return arrs
            }
        //            .bind(to: sdasd)
        
        //            .bind(to: calendarView.collectionView.rx.items(cellIdentifier: CalendarCollectionViewCell.NibName, cellType: CalendarCollectionViewCell.self)) { idx, schedule, cell in
        //
        //            }.disposed(by: disposeBag)
        //            .map { schedules in
        //                for i in schedules.enumerated() {
        //                    UnixStampToDate(with: i.element.startTime)
        //
        //                }
        //            }
    }
    
    
    
    private func bindAction() {
        Observable.merge(previousMonthBtn.rx.tap.map {
            Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
        }, nextMonthBtn.rx.tap.map {
            Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!
        })
        .map { date in
            self.calendarView.setCurrentPage(date, animated: true)
            
        }
        
        
        changeViewBtn.rx.tap
            .bind { _ in
                self.value.toggle()
                self.changeHidden(value: self.value)
            }
            .disposed(by: disposeBag)
    }
    
    func getSchedule(with year: Int, with month: Int) -> Observable<ScheduleModel> {
        return SMSAPIClient.shared.networking(from: .schedules(year, month))
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
        
        a.map { $0.schedules ?? [] }
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                cell.scheduleDateLbl.text = UnixStampToStringDate(with: schedule.startTime) + " ~ " + UnixStampToStringDate(with: schedule.endTime)
                cell.scheduleInfoLbl.text = schedule.detail
                
            }.disposed(by: disposeBag)
    }
    
    private func calendarSetting() {
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendarView.today = nil
        calendarView.placeholderType = .none
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17)
        calendarView.appearance.headerDateFormat = formType.month.rawValue
        calendarView.appearance.borderRadius = 0
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.weekdayTextColor = .black
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func changeHidden(value: Bool) {
        previousMonthBtn.isHidden = !value
        nextMonthBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
}


extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource, UICollectionViewDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        cell.preferredEventSelectionColors = [.customPurple, .calendarEventRed]
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -cell.frame.height + cell.frame.height / 1.1)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return  [.customPurple, .calendarEventRed]
    }
    
    // 선택됐을 때 그림자
    // 이벤트를 사각형으로
    
    
    //    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    //        // 짝수의 눌림때마다 2번눌러야 풀림 -> 해결해야함
    //        if firstDate == nil {
    //            firstDate = date
    //        } else {
    //            calendar.deselect(firstDate!)
    //            firstDate = nil
    //        }
    //        self.configureVisibleCells()
    //    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        // 어떻게 쓸지 고민
    //        cell.layer.masksToBounds = true
    //        let count = 2
    //        if count == 2 {
    //            cell.layer.cornerRadius = 17
    //            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    //        } else if indexPath.row == 1 {
    //            cell.layer.cornerRadius = 17
    //            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    //        }
    //    }
}

