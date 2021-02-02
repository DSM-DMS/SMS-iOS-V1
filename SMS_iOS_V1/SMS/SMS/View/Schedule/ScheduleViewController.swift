import UIKit

import RxSwift
import RxCocoa
import JTAppleCalendar

class ScheduleViewController: UIViewController, Storyboarded {
    let disposeBag = DisposeBag()

    var b = true
    var preEvent: [asd] = []

    var date: Date = Date() {
        didSet(oldValue) {
            getSchedule()
        }
    }

    lazy var schedules: [Schedules]? = []

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

    /// 셀 register 및 캘린더 시작
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: DayCell.NibName, for: indexPath) as! DayCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    /// 셀 초기화를 위한 함수
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        var cell = cell as! DayCell
        let myDate = date + 32400

        for i in 0..<schedules!.count {
            let start: Date = unix(with: (schedules![i].startTime / 1000) - 32400)
            let end: Date = unix(with: schedules![i].endTime / 1000)
//            print(myDate)
            if calendar.generateDateRange(from: start, to: end).contains(myDate) {
                cell = handleEvent(cell, schedules![i].uuid, myDate)
            }
        }
        handleCellHidden(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) { // 그 날짜에 맞는 옵저버해서 뭐 하던지 -> 포문을 돌려서 스타트  6 7 8


    }

    /// 스크롤 후 변경되는 날짜에 따른 날짜 변경을 위한 메소드
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.date = visibleDates.monthDates[0].date
    }

    /// 시작날짜와 끝날짜를 정하는 메소드
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = globalDateFormatter(.untilDay, "2020-01-01")
        let endDate = globalDateFormatter(.untilDay, "2030-01-01")

        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }

    /// 달력 헤더의 날짜와 셀들의 날짜, 셀들의 isHidden을 담당하는 메소드
    func handleCellHidden(cell: DayCell, cellState: CellState) {
        cell.dateLbl.text = cellState.text

        calendar.visibleDates { visibledate in
            self.monthLbl.text = globalDateFormatter(.month, visibledate.monthDates.first!.date)
        }

        if cellState.dateBelongsTo != .thisMonth {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
    }

    /// 이벤트 처리를 위한 메소드
    func handleEvent(_ todayCell: DayCell, _ uuid: String, _ date: Date) -> DayCell {
        todayCell.cellEvent.append(asd(uuid: uuid, date: date))
        print(preEvent)
        for eventCnt in 0..<todayCell.cellEvent.count { // 1
                for yesterEventCnt in 0..<preEvent.count { // 1
                    if preEvent.count == 0 && todayCell.cellEvent.count == 0 {
                        todayCell.event1View.isHidden = false
                    } else if todayCell.cellEvent[eventCnt].uuid == preEvent[yesterEventCnt].uuid {
                        switch yesterEventCnt {
                        case 0:
                            todayCell.event1View.isHidden = false
                        case 1:
                            todayCell.event2View.isHidden = false
                        default:
                            todayCell.event3View.isHidden = false
                        }
                    } else if todayCell.event2View.isHidden {
                        todayCell.event2View.isHidden = false
                    } else {
                        todayCell.event3View.isHidden = false
                    }
                }
            }
        preEvent = todayCell.cellEvent // 1
        return todayCell
        }




        //       1. 오늘 이벤트 카운트
        //       2. 전날의 이벤트 카운트 수
        //       3. 각 층마다 이벤트 uuid가 같은지 체크
        //       3-1. 만약 같다면 똑같은 자리에다 긋기
        //       3-2. 같지 않다면 그냥 오늘 날짜에 맞게 긋기 (자리 알아서)


}

extension ScheduleViewController {
    /// 프로퍼티에 있는 날짜에 맞게 통신을 담당하는 메소드
    func getSchedule() {
        Observable.just(globalDateFormatter(.month, self.date))
            .map { dateIntArr($0) }
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { arr -> Observable<ScheduleModel> in
                return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
            }.bind { schedules in
                self.schedules = schedules.schedules
            }.disposed(by: disposeBag)
    }

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

    private func changeHidden(_ value: Bool) {
        tableView.isHidden = value
        timeScheduleView.isHidden = !value
        calendarView.isHidden = value
        headerView.isHidden = value
    }

    /// 전 달인지 다음 달인지 확인 후 날짜 변경 및 달력 스크롤
    func previousOrNext(_ value: Bool) {
        var dateInterval: TimeInterval
        var segenmet: SegmentDestination
        dateInterval = value ? -2529000 : 2529000
        segenmet = value ? .previous : .next
        self.date = Date(timeInterval: dateInterval, since: self.date)
        self.calendar.scrollToSegment(segenmet)
    }
}

extension ScheduleViewController {
    private func bindAction() {
        previousBtn.rx.tap
            .bind { _ in
                self.previousOrNext(true)
            }.disposed(by: disposeBag)

        nextBtn.rx.tap
            .bind { _ in
                self.previousOrNext(false)
            }.disposed(by: disposeBag)

        changeViewBtn.rx.tap
            .bind { _ in
                self.changeHidden(self.b)
                self.b.toggle()
            }.disposed(by: disposeBag)
    }
}

extension JTACMonthView {
    func selectEvents(_ calendar: JTACMonthView, _ dates: [Date]) {
        //        let cell = calendar.
        // 내가 원하는건 시작날짜부터 끝나는 날짜까지의 해당되는 셀
    }
}

