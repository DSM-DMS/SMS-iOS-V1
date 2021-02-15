import UIKit

import RxSwift
import RxCocoa
import FSCalendar

class ScheduleViewController: UIViewController, Storyboarded {
    var value = false
    weak var coordinator: ScheduleCoordinator?
    let disposeBag = DisposeBag()
    private lazy var schedules: [Schedules]? = []
    private var preDict: [Date: [ScheduleData]] = [:]
    
    var date: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    var dateForTable: BehaviorRelay<Date> = BehaviorRelay(value: Date())
    
    @IBOutlet weak var changeViewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var timeScheduleView: TimeScheduleXib!
    
    lazy var previousBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "left"), for: .normal)
        button.frame = CGRect(x: calendarView.frame.midX - calendarView.frame.midX / 2, y: calendarView.frame.minY + 4, width: 8, height: 14)
        return button
    }()
    
    lazy var nextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right"), for: .normal)
        button.frame = CGRect(x: calendarView.frame.midX + calendarView.frame.midX / 2, y: calendarView.frame.minY + 4, width: 8, height: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarSetting()
        self.tableViewSetting()
        bindAction()
        tableViewBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSchedule()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.disappear()
    }
}

//MARK- extension
extension ScheduleViewController {
    private func bindAction() {
        previousBtn.rx.tap
            .bind {
                let date = Calendar.current.date(byAdding: .month, value: -1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        nextBtn.rx.tap
            .bind {
                let date = Calendar.current.date(byAdding: .month, value: +1, to: self.calendarView.currentPage)!
                self.calendarView.setCurrentPage(date, animated: true)
            }.disposed(by: disposeBag)
        
        changeViewBtn.rx.tap
            .bind {
                self.value.toggle()
                self.changeHidden(value: self.value)
            }
            .disposed(by: disposeBag)
    }
    
    private func getSchedule() {
        self.date.map { nDate -> String in
            return globalDateFormatter(.month, nDate)
        }.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
        .map { dateIntArr($0) }
        .debounce(.seconds(2), scheduler: MainScheduler.instance)
        .flatMap { arr -> Observable<ScheduleModel> in
            return SMSAPIClient.shared.networking(from: .schedules(arr[0], arr[1]))
        }.observeOn(MainScheduler.instance)
        .bind { schedules in
            self.schedules = schedules.schedules
            self.calendarView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    private func calendarSetting() {
        calendarView.today = nil
        calendarView.delegate = self
        calendarView.dataSource = self
        nextBtn.layer.zPosition = 1
        previousBtn.layer.zPosition = 1
        self.view.addSubviews([previousBtn, nextBtn])
        calendarView.placeholderType = .none
        calendarView.appearance.selectionColor = nil
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0;
        calendarView.appearance.titleSelectionColor = UIColor.black
        calendarView.appearance.headerDateFormat = formType.month.rawValue
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 17)
        calendarView.register(DayCell.self, forCellReuseIdentifier: DayCell.NibName)
        calendarView.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
    }
    
    private func changeHidden(value: Bool) {
        previousBtn.isHidden = !value
        nextBtn.isHidden = !value
        calendarView.isHidden = !value
        tableView.isHidden = !value
        timeScheduleView.isHidden = value
    }
    
    public func generateDateRange(from startDate: Date, to endDate: Date) -> [Date] {
        let calendar = Calendar.current
        if startDate > endDate { return [] }
        var returnDates: [Date] = []
        var currentDate = startDate
        repeat {
            returnDates.append(currentDate + 32400)
            currentDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: currentDate)!)
        } while currentDate <= endDate
        return returnDates
    }
    
    func dispatchViewHidden(_ view: UIView, _ time: Int = 10) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .nanoseconds(time)) {
            view.isHidden = false
        }
    }
    
    func ascEvent() -> [Int] {
        var a: [(Date, Int)] = []
        for i in 0..<schedules!.count {
            let start: Date = unix(with: (schedules![i].startTime / 1000) - 32400)
            a.append((start, i))
        }
        a.sort(by: <)
        var d: [Int] = []
        for i in 0..<schedules!.count {
            d.append(a[i].1)
        }
        
        return d
    }
}

extension ScheduleViewController: UITableViewDelegate {
    private func tableViewBind() {
        self.dateForTable.map { self.preDict[$0 + 32400] ?? [] }
            .bind(to: tableView.rx.items(cellIdentifier: ScheduleCell.NibName, cellType: ScheduleCell.self)) { idx, schedule, cell in
                cell.scheduleDateLbl.text = "\(schedule.date)"
                cell.scheduleInfoLbl.text = schedule.detail
                switch schedule.place {
                case 1:
                    cell.scheduleColorView.backgroundColor = .customPurple
                case 2:
                    cell.scheduleColorView.backgroundColor = .customRed
                default:
                    cell.scheduleColorView.backgroundColor = .customYellow
                }
            }.disposed(by: disposeBag)
    }
    
    private func tableViewSetting() {
        tableView.delegate = self
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
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        getSchedule()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: DayCell.NibName, for: date, at: position) as! DayCell
        cell.hiddenAll()
        let cnt = schedules?.count ?? 0
        
        for i in 0..<cnt {
            let start: Date = unix(with: (schedules![ascEvent()[i]].startTime / 1000) - 32400)
            let end: Date = unix(with: schedules![ascEvent()[i]].endTime / 1000)
            
            if generateDateRange(from: start, to: end).contains(date + 32400) {
                handleEvent(cell as! DayCell, schedules![ascEvent()[i]].uuid, date + 32400, schedules![ascEvent()[i]].detail, position)
            }
        }
        return cell
    }
    
    private func handleEvent(_ todayCell: DayCell, _ uuid: String, _ date: Date, _ detail: String, _ monthPostion: FSCalendarMonthPosition) -> FSCalendarCell {
        
        // 그날 이벤트를 내가 이미 해뒀다면 미리 처리 해야함
        //        if todayCell.todaySet(dat, <#T##detail: String##String#>)
        
        let preEvent = preDict[date - 86400] ?? []
        print(date)
        
        if preEvent.count == 0 && todayCell.cellEvent.count == 0 {
            dispatchViewHidden(todayCell.event1View)
            todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, place: 1))
            preDict.updateValue(todayCell.todaySet(date, detail), forKey: date)
            return todayCell
        }
        
        var a: Int = 0
        
        for yesterEventCnt in 0..<preEvent.count {
            if uuid == preEvent[yesterEventCnt].uuid {
                switch preEvent[yesterEventCnt].place {
                case 1:
                    dispatchViewHidden(todayCell.event1View)
                    a = 1
                case 2:
                    dispatchViewHidden(todayCell.event2View)
                    a = 2
                case 3:
                    dispatchViewHidden(todayCell.event3View)
                    a = 3
                default: break
                }
            } else {
                if todayCell.cellEvent.count == 0 && preEvent.count == 0 {
                    dispatchViewHidden(todayCell.event1View)
                    a = 1
                } else if todayCell.cellEvent.count == 1 && preEvent.count == 1{
                    dispatchViewHidden(todayCell.event2View)
                    a = 2
                } else if todayCell.cellEvent.count == 2 && preEvent.count == 2 {
                    dispatchViewHidden(todayCell.event3View)
                    a = 3
                }
            }
        }
        todayCell.cellEvent.append(ScheduleData(uuid: uuid, date: date, detail: detail, place: a))
        preDict.updateValue(todayCell.todaySet(date, detail), forKey: date)
        return todayCell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateForTable.accept(date)
        let cell = calendar.cell(for: date, at: monthPosition)
        
        let layer = cell!.contentView.layer
        layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.35
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.cornerRadius = cell!.fs_width / 10
        layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    // 이게 왜 안될까
    //        cell!.contentView.addShadow(offset: CGSize(width: 2, height: 2), color: .gray, shadowRadius: 2, opacity: 0.35, cornerRadius: cell!.fs_width / 10)
    //        cell!.contentView.layer.masksToBounds = false
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.cell(for: date, at: monthPosition)!.contentView.layer.shadowOpacity = 0
    }
}
